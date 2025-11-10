//
//  ChatSection.swift
//  FindMEmory
//
//  Created by 권예원 on 11/3/25.
//

import SwiftUI

struct Message: Identifiable {
    let id: UUID = UUID()
    let user: String
    let text: String
    let time: Date
    let isMe: Bool
    let profileImage: String // 시스템 이미지명 또는 URL
}


struct ChatSection: View {
    
    @State private var messages: [Message] = [
        Message(user: "김탄", text: "너나좋아하냐", time: Date() , isMe: false, profileImage:  "person.circle.fill"),
        Message(user: "차은상", text: "하하하하하하하하하하하",time: Date(), isMe: true, profileImage:  "person.circle.fill")
    ]
    @State private var newMessage: String = ""
    
    var body: some View {
        VStack(spacing: 0) {
            // 채팅 리스트
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
    }

    private func sendMessage() {
        guard !newMessage.isEmpty else { return }
        messages.append(Message(user: "나",
                                text: newMessage,
                                time: Date(),
                                isMe: true,
                                profileImage:  "person.circle.fill"))
        newMessage = ""
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
