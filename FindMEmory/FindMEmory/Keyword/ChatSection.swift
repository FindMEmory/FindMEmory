//
//  ChatSection.swift
//  FindMEmory
//
//  Created by 권예원 on 11/3/25.
//

import SwiftUI

struct ChatMessageDTO: Codable, Identifiable { // JSON 수신 DTO
    let chat_id: Int
    let keyword_id: Int
    let sender_id: Int
    let body: String
    let created_at: String
    let user_name: String

    var id: Int { chat_id } // 고유 ID
}

extension ChatMessageDTO { // UI 전용 모델로 전환
    func toUIMessage(myId: Int) -> Message {
        Message(
            id: chat_id,
            user: user_name,
            text: body,
            time: convertDate(created_at),
            isMe: sender_id == myId,
            profileImage: "person.circle.fill"
        )
    }

    private func convertDate(_ str: String) -> Date { // 날짜 Date 타입으로 변환
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: str) ?? Date()
    }
}

struct Message: Identifiable { // UI용 채팅 모델
    let id: Int
    let user: String
    let text: String
    let time: Date
    let isMe: Bool
    let profileImage: String
}


struct ChatSection: View {

    @AppStorage("user_id") private var myUserId: Int = 0 // 로그인 사용자 ID

    let keywordId: Int // 현재 채팅이 속한 키워드 ID

    @State private var messages: [Message] = [] // 채팅 메시지 목록
    @State private var newMessage: String = "" // 새로운 채팅 메시지
    @State private var lastId: Int = 0 // 마지막 수신 채팅 ID
    @State private var fetchTimer: Timer? // 메시지 조회 타이머

    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { proxy in // 마지막 메시지 자동 스크롤 목적
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(messages) { message in
                            MessageRow(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) { // 메시지 개수 변하면 마지막 메시지로 자동 스크롤
                    if let last = messages.last?.id {
                        withAnimation {
                            proxy.scrollTo(last, anchor: .bottom)
                        }
                    }
                }
            }

            ChatInputView(text: $newMessage) {
                sendMessage()
            }
            .padding()
            .background(Color(.systemGray6))
        }
        .onAppear {
            startFetchMessage()
        }
        .onDisappear {
            stopFetchMessage()
        }
    }

    private func sendMessage() {

        guard myUserId != 0 else {
            print("로그인 안 된 상태")
            return
        }

        guard !newMessage.isEmpty else { return } // 빈 메시지 전송 방지

        guard let url = URL(string: "http://124.56.5.77/IUI/sendMessage.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST" // POST 방식 요청
        request.setValue(
            "application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type"
        )

        let bodyString =
        "keyword_id=\(keywordId)&sender_id=\(myUserId)&body=\(newMessage)"
        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request).resume()

        newMessage = "" // 입력창 초기화
    }


    private func startFetchMessage() {
        stopFetchMessage() // 기존 타이머 정지
        fetchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            fetchMessages()
        } // 새로 타이머 시작
    }

    private func stopFetchMessage() {
        fetchTimer?.invalidate() // 타이머 무효화
        fetchTimer = nil
    }

    // MARK: - Fetch Messages
    private func fetchMessages() {

        guard let url = URL(
            string: "http://124.56.5.77/IUI/fetchMessage.php?keyword_id=\(keywordId)&last_id=\(lastId)"
        ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print("요청 에러:", error)
                return
            }

            guard let data else { return }

            do {
                let dtos = try JSONDecoder().decode([ChatMessageDTO].self, from: data) // JSON 응답을 DTO 형태로 디코딩
                guard dtos.isEmpty == false else { return }

                DispatchQueue.main.async {
                    for dto in dtos {
                        messages.append(dto.toUIMessage(myId: myUserId)) // UI 모델로 변환해서 메시지 목록에 추가
                    }
                    lastId = dtos.last?.chat_id ?? lastId // 마지막 메시지 ID 갱신
                }
            } catch {
                print("디코딩 오류:", error)
            }
        }.resume()
    }
}


struct ChatInputView: View {
    @Binding var text: String
    var onSend: () -> Void

    var body: some View {
        HStack {
            TextField("채팅을 입력하세요.", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .font(.system(size: 22))
            }
            .padding(.horizontal, 4)
        }
    }
}


struct MessageRow: View {
    let message: Message

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {

            if !message.isMe { // 상대방 메시지
                Image(systemName: message.profileImage)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .foregroundColor(.gray)

                VStack(alignment: .leading, spacing: 4) {
                    Text(message.user)
                        .font(.caption)
                        .foregroundColor(.gray)

                    HStack(alignment: .bottom, spacing: 6) {
                        Text(message.text)
                            .padding(10)
                            .background(Color(.systemGray5))
                            .clipShape(RoundedRectangle(cornerRadius: 12))

                        Text(message.time.formatted(date: .omitted, time: .shortened))
                            .font(.caption2)
                            .foregroundColor(.gray)
                            .padding(.bottom, 2)
                    }
                }

                Spacer()
            } else { // 내가 보낸 메시지
                Spacer()

                HStack(alignment: .bottom, spacing: 6) {
                    Text(message.time.formatted(date: .omitted, time: .shortened))
                        .font(.caption2)
                        .foregroundColor(.gray)
                        .padding(.bottom, 2)

                    Text(message.text)
                        .padding(10)
                        .background(Color.blue.opacity(0.85))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
        }
        .padding(.horizontal)
    }
}

// MARK: - Preview
#Preview {
    UserDefaults.standard.set(1, forKey: "user_id")
    return ChatSection(keywordId: 2)
}
