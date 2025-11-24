//
//  QuestionBoxItem.swift
//  FindMEmory
//
//  Created by 정서영 on 11/10/25.
//

import SwiftUI
struct QuestionBoxItem {
    let id = UUID()
    let image: Image
    let solving: Bool
    let title: String
    let heartCount: Int
    let chattingCount: Int
}

struct QuestionBoxItemView: View {
    let card: QuestionBoxItem
    
    var body: some View {
        VStack {
            ZStack(alignment: .topLeading){
                card.image
                    .resizable()
                    .frame(width: 100, height: 107)
                    .cornerRadius(8)
                Text(card.solving ? "해결" : "")
                    .foregroundStyle(.white)
                    .background(.green)
                    .padding(10)
            }
            VStack(alignment: .trailing, spacing: 12) {
                Text(card.title)
                    .font(.headline)
                    .frame(width: 100, height: 33)
                HStack(spacing: 6) {
                    Image(systemName: "heart.fill")
                    Text("\(card.heartCount)")
                    Image(systemName: "ellipsis.message.fill")
                    Text("\(card.chattingCount)")
                }
            }
        }
        .padding()
    
    }
}

#Preview {
    QuestionBoxItemView(card: QuestionBoxItem(
        image: Image(systemName: "photo"),
        solving: true,
        title: "SwiftUI 질문입니다",
        heartCount: 12,
        chattingCount: 3,
    ))
}
