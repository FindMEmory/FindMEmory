//
//  QuestionPostSection.swift
//  FindMEmory
//
//  Created by Jung Hyun Han on 12/13/25.
//

import SwiftUI

struct QuestionPostSection: View {
    let questionTitle: String
    let questionBody: String
    let questionNickname: String
    let questionDate: String

    let likeCount: Int
    let isLiked: Bool
    let onLikeTap: () -> Void

    let commentCount: Int

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {

            // 작성자 정보
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 40, height: 40)

                VStack(alignment: .leading, spacing: 2) {
                    Text(questionNickname)
                        .font(.system(size: 15, weight: .semibold))
                    Text(questionDate)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                }

                Spacer()

                Text("B")
                    .font(.system(size: 12, weight: .bold))
                    .padding(6)
                    .background(Color.gray.opacity(0.2))
                    .clipShape(Circle())
            }

            // 제목 + 내용
            Text(questionTitle)
                .font(.system(size: 18, weight: .bold))

            Text(questionBody)
                .font(.system(size: 15))
                .lineSpacing(4)

            // 이미지 (임시)
            HStack(spacing: 8) {
                ForEach(0..<3) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 100, height: 100)
                }
            }

            // 좋아요 + 댓글 수
            HStack(spacing: 12) {
                Button(action: onLikeTap) {
                    HStack(spacing: 4) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .foregroundStyle(isLiked ? .red : .gray)

                        Text("\(likeCount)")
                    }
                }

                Label("댓글 \(commentCount)", systemImage: "text.bubble")
                    .foregroundColor(.gray)

                Spacer()
            }
            .font(.system(size: 14, weight: .medium))

            Divider()
        }
    }
}
