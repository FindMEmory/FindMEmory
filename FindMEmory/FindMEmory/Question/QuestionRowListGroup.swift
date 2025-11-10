//
//  QuestionRowListGroup.swift
//  FindMEmory
//
//  Created by 정서영 on 11/10/25.
//

import SwiftUI

struct SortItem {
    let sortItem: String
}

struct QuestionRowListGroup: View {
    let sortItem: SortItem
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text(sortItem.sortItem)
                    
                    Spacer()
                    NavigationLink("더보기", destination: QuestionListView())
                }
                .padding(.horizontal)
                HStack{
                    QuestionBoxItemView(card: QuestionBoxItem(
                        image: Image(systemName: "photo"),
                        solving: true,
                        title: "SwiftUI 질문입니다",
                        heartCount: 12,
                        chattingCount: 3,
                    ))
                    
                    QuestionBoxItemView(card: QuestionBoxItem(
                        image: Image(systemName: "photo"),
                        solving: true,
                        title: "SwiftUI 질문입니다",
                        heartCount: 12,
                        chattingCount: 3,
                    ))
                    
                    QuestionBoxItemView(card: QuestionBoxItem(
                        image: Image(systemName: "photo"),
                        solving: true,
                        title: "SwiftUI 질문입니다",
                        heartCount: 12,
                        chattingCount: 3,
                    ))
                }
            }
            .padding()
        }
    }
}

#Preview {
    QuestionRowListGroup(sortItem: SortItem(
        sortItem: "인기 질문"
    ))
}
