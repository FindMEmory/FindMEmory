//
//  Question.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI
struct QuestionCard {
    let id: Int
    let image: Image
    let solving: Bool
    let title: String
    let content: String
    let heartCount: Int
    let chattingCount: Int
    let writer: Int
    let date: String
}

struct QuestionCardView: View {
    let card: QuestionCard

    var body: some View {
        NavigationLink(destination: QuestionDetailView( questionId: card.id)){
            HStack(alignment: .top, spacing: 12) {
                ZStack(alignment: .topLeading){
                    card.image
                        .resizable()
                        .foregroundStyle(.gray)
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
                        .foregroundStyle(.black)
                    Text(card.content)
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .lineLimit(2)
                    Spacer()
                    HStack(spacing: 6) {
                        Image(systemName: "heart.fill")
                            .foregroundStyle(.red)
                        Text("\(card.heartCount)")
                            .foregroundStyle(.black)
                        Image(systemName: "ellipsis.message.fill")
                            .foregroundStyle(.blue)
                        Text("\(card.chattingCount)")
                            .foregroundStyle(.black)
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
}

#Preview {
    QuestionCardView(card: QuestionCard(
        id: 1,
        image: Image(systemName: "photo"),
        solving: true,
        title: "SwiftUI 질문입니다",
        content: "List 안에서 ForEach를 사용할 때 id를 어떻게 줘야 하는지 궁금합니다.",
        heartCount: 12,
        chattingCount: 3,
        writer: 1,
        date: "2025-11-03"
    ))
}
