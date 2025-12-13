//
//  CommentsModel.swift
//  FindMEmory
//
//  Created by Jung Hyun Han on 12/13/25.
//

import SwiftUI

// MARK: - Comment Model
struct Comment: Identifiable {
    let id: Int
    let authorId: Int
    let nickname: String
    let text: String
    let date: String
    let isAccepted: Bool
}

struct CommentRow: View {
    let comment: Comment

    let isQuestionOwner: Bool
    let onAccept: () -> Void
    let onDelete: () -> Void

    @AppStorage("user_id") var userId: Int = 0
    var isMine: Bool { comment.authorId == userId }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 32, height: 32)

                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        Text(comment.nickname)
                            .font(.system(size: 14, weight: .semibold))

                        Text("B")
                            .font(.system(size: 11, weight: .bold))
                            .padding(4)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }

                    Text(comment.text)
                        .font(.system(size: 14))
                }

                Spacer()

                // ✅ 1. 채택된 댓글이면 뱃지
                if comment.isAccepted {
                    Text("채택됨")
                        .font(.system(size: 12, weight: .bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.15))
                        .foregroundColor(.green)
                        .cornerRadius(6)
                }

                // ✅ 2. 내가 쓴 댓글 → 삭제
                else if isMine {
                    Button("삭제하기") { onDelete() }
                        .font(.system(size: 12))
                        .padding(6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                }

                // ✅ 3. 내가 쓴 글 + 남이 쓴 댓글 → 채택
                else if isQuestionOwner {
                    Button("채택하기") { onAccept() }
                        .font(.system(size: 12))
                        .padding(6)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(6)
                }
            }

            Text(comment.date)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}
