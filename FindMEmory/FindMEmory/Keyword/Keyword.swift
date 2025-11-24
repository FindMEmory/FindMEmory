//
//  Keyword.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

//
//  Keyword.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct Keyword: View {
    
    var keywordName: String
    var questionCount: Int = 0
    var participantCount: Int = 0  
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(keywordName)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            
            Group {
                Text("게시글 \(questionCount)")
                Text("현재 \(participantCount)명 참여중")
            }
            .font(.system(size: 12))
            .foregroundColor(.gray)
            
            Spacer().frame(height: 10)
            
            Image(systemName: "photo")
                .resizable()
                .frame(width: 120, height: 120)
                .foregroundColor(.black)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 15)
                .stroke(.gray, style: StrokeStyle(lineWidth: 1))
        )
    }
}

#Preview {
    Keyword(keywordName: "상속자들")
}
