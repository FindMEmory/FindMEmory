//
//  KeywordDetailView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct KeywordDetailView: View {
    
    var keywordName : String = "상속자들"
    var questionCount : Int = 0
    var participantCount : Int = 0
    
    @State var searchKeyword: String = ""
    
    var body: some View {
        VStack {
            header
                .padding(20)
            searchBar
                .padding(10)
            questionList
                .padding(10)
            liveChat
        }
        .padding(.horizontal, 15)
    }
    
    var header : some View {
        HStack(spacing: 20){
            Image(systemName: "photo")
                .resizable()
                .frame(width: 80, height: 80)
            VStack(alignment:.leading){
                Text(keywordName)
                    .font(.system(size: 20, weight: .bold))
                Group{
                    Text("게시글 \(questionCount)")
                    Text("현재 \(participantCount)명 참여중")
                }
                .font(.system(size: 15))
                .foregroundStyle(.gray)
            }
            Spacer()
        }
    }
    
    var searchBar : some View {
        TextField("검색", text: $searchKeyword)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.gray,lineWidth: 1)
            )
    }
    
    
    var questionList : some View {
        VStack(){
            HStack{
                Text("게시글")
                Spacer()
                Button(action: {
                    
                }, label: {
                    HStack{
                        Text("더보기")
                        Image(systemName: "chevron.right")
                            .font(.system(size: 15))
                    }
                    .foregroundStyle(.gray)
                })
            }
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 12) {
                    ForEach(0..<5, id: \.self) { index in
                        QuestionV(
                            questionTitle: "이 캐릭터 나온 만화 아는사람 \(index+1)",
                            likeCount: Int.random(in: 10...100),
                            commentCount: Int.random(in: 0...50)
                        )
                    }
                }
            }
        }

    }
    
    var liveChat : some View {
        VStack(alignment: .leading){
            Text("실시간 채팅")
            ChatSection()
                .background(
                    Rectangle()
                        .foregroundStyle(.gray.opacity(0.1))
                )
        }
    }
}

#Preview {
    KeywordDetailView()
}
