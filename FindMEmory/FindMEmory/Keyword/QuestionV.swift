//
//  QuestionV.swift
//  FindMEmory
//
//  Created by 권예원 on 11/3/25.
//

import SwiftUI

struct QuestionV: View {
    var questionTitle: String = "이 캐릭터 나온 만화 아는사람"
    var likeCount: Int = 50
    var commentCount: Int = 20
    
    var body: some View {
        VStack {
            Image(systemName: "photo")
                .resizable()
                .frame(width: 107, height: 107)
                .foregroundStyle(.black)
            Text("\(questionTitle)")
                .frame(width: 110, alignment: .leading)
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
                .lineLimit(2)
                .fixedSize(horizontal: true, vertical: true)
            Spacer().frame(height: 10)
            HStack(spacing: 4){
                Image(systemName: "heart.fill")
                    .foregroundStyle(.pink)
                Text("\(likeCount)")
                    .foregroundStyle(.black)
                Image(systemName: "ellipsis.message.fill")
                    .foregroundStyle(.blue)
                Text("\(commentCount)")
                    .foregroundStyle(.black)
            }
            .frame(width: 110, alignment: .trailing)
        }
        .padding(10)

    }
}

#Preview {
    QuestionV()
}
