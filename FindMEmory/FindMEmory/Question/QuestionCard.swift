//
//  Question.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI
struct QuestionCard {
    let id = UUID()
    let image: Image
    let solving: Bool
    let title: String
    let content: String
    let heartCount: Int
    let chattingCount: Int
    let writer: String
    let date: String
}

struct QuestionCardView: View {
    let card: QuestionCard

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack(alignment: .topLeading){
                card.image
                    .resizable()
                    .frame(width: 107, height: 107)
                    .cornerRadius(8)
                Text(card.solving ? "해결" : "")
                    .foregroundStyle(.white)
                    .background(.green)
                    .padding(10)
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(card.title)
                    .font(.headline)
                Text(card.content)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(2)
                Spacer()
                HStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                    Text("\(card.heartCount)")
                    Image(systemName: "ellipsis.message.fill")
                    Text("\(card.chattingCount)")
                    Text("| \(card.writer) | \(card.date)")
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
            .frame(height: 107)
        }
        .padding()
    }
}

#Preview {
    QuestionCardView(card: QuestionCard(
        image: Image(systemName: "photo"),
        solving: true,
        title: "SwiftUI 질문입니다",
        content: "List 안에서 ForEach를 사용할 때 id를 어떻게 줘야 하는지 궁금합니다.",
        heartCount: 12,
        chattingCount: 3,
        writer: "서영",
        date: "2025-11-03"
    ))
}
