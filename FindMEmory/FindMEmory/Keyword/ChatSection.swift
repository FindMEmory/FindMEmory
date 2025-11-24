//
//  ChatSection.swift
//  FindMEmory
//
//  Created by 권예원 on 11/3/25.
//

import SwiftUI

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
            user: self.user_name,
            text: self.body,
            time: convertDate(self.created_at),
            isMe: self.sender_id == myId,
            profileImage: "person.circle.fill"
        )
    }
    func convertDate(_ str: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.date(from: str) ?? Date()
    }
}


struct Message: Identifiable {
    let id: UUID = UUID()
    let user: String
    let text: String
    let time: Date
    let isMe: Bool
    let profileImage: String
}


struct ChatSection: View {
    
    let myUserId = 1001
    let keywordId = 4
    
    @State private var messages: [Message] = []
    @State private var newMessage: String = ""
    @State private var lastId: Int = 0
    
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

            // 하단 입력창
            ChatInputView(text: $newMessage) {
                sendMessage()
            }
            .padding()
            .background(Color(.systemGray6))
        }
        .onAppear{
            startFetchMessage()
        }
    }

    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        
        let url = URL(string: "http://localhost/findmemory/sendMessage.php")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")
        
        let bodyString = "keyword_id=\(keywordId)&sender_id=\(myUserId)&body=\(newMessage)"
        request.httpBody = bodyString.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request).resume()
        
        messages.append(
            Message(
                user: "나",
                text: newMessage,
                time: Date(),
                isMe: true,
                profileImage: "person.circle.fill"
            )
        )
        newMessage = ""
    }
    
    func startFetchMessage() {

        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            
            guard let url = URL(string:
                    "http://127.0.0.1/findmemory/fetchMessage.php?keyword_id=\(keywordId)&last_id=\(lastId)"
            ) else {
                print("URL Error")
                return
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    print("요청 에러:", error)
                    return
                }
                
                guard let data = data else {
                    print("데이터 없음")
                    return
                }
                
                let str = String(decoding: data, as: UTF8.self)
                print("서버 응답:", str)
                
                do {
                    let dtos = try JSONDecoder().decode([ChatMessageDTO].self, from: data)
                    
                    if dtos.isEmpty == false {
                        DispatchQueue.main.async {
                            for dto in dtos {
                                let uiMsg = dto.toUIMessage(myId: myUserId)
                                messages.append(uiMsg)
                            }
                            lastId = dtos.last?.chat_id ?? lastId
                        }
                    }
                    
                } catch {
                    print("디코딩 오류:", error)
                }
                
            }.resume()
        }
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
            // 왼쪽(상대방 메시지)
            if !message.isMe {
                // 프로필
                Image(systemName: message.profileImage)
                    .resizable()
                    .frame(width: 36, height: 36)
                    .clipShape(Circle())
                    .foregroundColor(.gray)

                // 이름 + 말풍선 + 시간
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
            }
            // 오른쪽(내 메시지)
            else {
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



#Preview {
    ChatSection()
}
