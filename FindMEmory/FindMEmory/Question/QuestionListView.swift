//
//  QuestionListView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct QuestionListView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            HeaderGroup
            FilteringGroup
            QuestionListGroup
            Spacer()
        }
    }
    
    private var HeaderGroup: some View {
        ZStack{
            HStack{
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.backward")
                        .tint(.black)
                })
                Spacer()
            }
            .padding()
            Text("최근 질문")
        }
    }
    
    private var FilteringGroup: some View {
        HStack{
            Spacer().frame(width: 40)
            Button(action: {}, label: {
                Text("해결")
                    .foregroundStyle(.black)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.gray, lineWidth: 1)
                            .frame(width: 68)
                    )
            })
            Spacer().frame(width: 50)
            Button(action: {}, label: {
                Text("미해결")
                    .foregroundStyle(.black)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.gray, lineWidth: 1)
                            .frame(width: 68)
                    )
            })
            Spacer()
        }
    }
    
    private var QuestionListGroup: some View {
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
}

#Preview {
    QuestionListView()
}
