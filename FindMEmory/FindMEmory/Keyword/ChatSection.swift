//
//  ChatSection.swift
//  FindMEmory
//
//  Created by 권예원 on 11/3/25.
//

import SwiftUI

// MARK: - DTO
struct ChatMessageDTO: Codable, Identifiable {
    let chat_id: Int
    let keyword_id: Int
    let sender_id: Int
    let body: String
    let created_at: String
    let user_name: String

    var id: Int { chat_id }
}

extension ChatMessageDTO {
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

    private func convertDate(_ str: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: str) ?? Date()
    }
}

// MARK: - UI Model
struct Message: Identifiable {
    let id: Int
    let user: String
    let text: String
    let time: Date
    let isMe: Bool
    let profileImage: String
}

// MARK: - Chat Section
struct ChatSection: View {

    @AppStorage("user_id") private var myUserId: Int = 0

    // 키워드별 채팅
    let keywordId: Int

    @State private var messages: [Message] = []
    @State private var newMessage: String = ""
    @State private var lastId: Int = 0
    @State private var fetchTimer: Timer?

    var body: some View {
        VStack(spacing: 0) {

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 8) {
                        ForEach(messages) { message in
                            MessageRow(message: message)
                                .id(message.id)
                        }
                    }
                    .padding()
                }
                .onChange(of: messages.count) {
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

    // MARK: - Send Message
    private func sendMessage() {

        guard myUserId != 0 else {
            print("⚠️ 로그인 안 된 상태")
            return
        }

        guard !newMessage.isEmpty else { return }

        guard let url = URL(string: "http://localhost/findmemory/sendMessage.php") else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(
            "application/x-www-form-urlencoded",
            forHTTPHeaderField: "Content-Type"
        )

        let bodyString =
        "keyword_id=\(keywordId)&sender_id=\(myUserId)&body=\(newMessage)"
        request.httpBody = bodyString.data(using: .utf8)

        URLSession.shared.dataTask(with: request).resume()

        newMessage = ""
    }

    // MARK: - Fetch Control
    private func startFetchMessage() {
        stopFetchMessage()
        fetchTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            fetchMessages()
        }
    }

    private func stopFetchMessage() {
        fetchTimer?.invalidate()
        fetchTimer = nil
    }

    // MARK: - Fetch Messages
    private func fetchMessages() {

        guard let url = URL(
            string: "http://127.0.0.1/findmemory/fetchMessage.php?keyword_id=\(keywordId)&last_id=\(lastId)"
        ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                print("요청 에러:", error)
                return
            }

            guard let data else { return }

            do {
                let dtos = try JSONDecoder().decode([ChatMessageDTO].self, from: data)
                guard dtos.isEmpty == false else { return }

                DispatchQueue.main.async {
                    for dto in dtos {
                        messages.append(dto.toUIMessage(myId: myUserId))
                    }
                    lastId = dtos.last?.chat_id ?? lastId
                }
            } catch {
                print("디코딩 오류:", error)
            }
        }.resume()
    }
}

// MARK: - Input View
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

// MARK: - Message Row
struct MessageRow: View {
    let message: Message

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {

            if !message.isMe {
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
            } else {
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
