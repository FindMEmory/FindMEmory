//
//  QuestionCommentSection.swift
//  FindMEmory
//
//  Created by Jung Hyun Han on 12/13/25.
//

import SwiftUI

struct QuestionCommentSection: View {
    let comments: [Comment]
    let acceptedCommentId: Int?
    let isQuestionOwner: Bool

    let onAccept: (Int) -> Void
    let onDelete: (Int) -> Void

    @Binding var commentText: String
    let onSend: () -> Void

    var body: some View {
        VStack(spacing: 0) {

            // 댓글 목록
            VStack(spacing: 12) {

                // 채택된 댓글
                ForEach(comments.filter { $0.id == acceptedCommentId }) { comment in
                    CommentRow(
                        comment: comment,
                        isQuestionOwner: isQuestionOwner,
                        onAccept: { onAccept(comment.id) },
                        onDelete: { onDelete(comment.id) }
                    )
                }

                // 나머지 댓글
                ForEach(comments.filter { $0.id != acceptedCommentId }) { comment in
                    CommentRow(
                        comment: comment,
                        isQuestionOwner: isQuestionOwner,
                        onAccept: { onAccept(comment.id) },
                        onDelete: { onDelete(comment.id) }
                    )
                }
            }
            .padding()

            // 댓글 입력
            HStack {
                TextField("댓글을 입력하세요.", text: $commentText)
                    .padding(10)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)

                Button(action: onSend) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(.white)
        }
    }
}

