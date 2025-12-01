//
//  MyPageView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        NavigationStack{
            HStack{
                Text("계정 정보")
                Spacer()
                NavigationLink(destination: NotificationView()){
                    Image(systemName: "bell")
                        .foregroundStyle(.black)
                }
            }
            .padding(.top, 50)
            .padding(.horizontal)
            
            VStack(spacing: 30){
                NavigationLink(destination: EditUserPageView()){
                    UserGroup
                }
                
                GradeGroup
                QuestionsGroup
                Spacer()
                Button(action: {}, label: {
                    Text("로그아웃")
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, maxHeight: 45)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(style: .init(lineWidth: 1) )
                            .foregroundStyle(.gray)
                    )
                })
                .padding(.horizontal)
            }
        }
    }
    
    private var UserGroup : some View {
        HStack{
            Image(.profile)
            VStack (alignment: .leading){
                Text("닉네임")
                Text("dafj")
            }
            .foregroundStyle(.gray)
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(style: .init(lineWidth: 1) )
                .foregroundStyle(.gray)
        )
        .padding(.horizontal)
    }
    
    private var GradeGroup : some View {
        VStack(alignment: .leading){
            Text("나의 등급")
            VStack(alignment: .leading){
                Text("다음 등급까지 채택 4개")
                    .foregroundStyle(.gray)
                Image(.grade)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(style: .init(lineWidth: 1) )
                    .foregroundStyle(.gray)
            )
        }
    }
    
    private var QuestionsGroup: some View {
        VStack{
            NavigationLink(destination: MyAskView()){
                HStack{
                    Text("내가 등록한 질문")
                        .foregroundStyle(.gray)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: .init(lineWidth: 1) )
                        .foregroundStyle(.gray)
                )
            }
            
            NavigationLink(destination: MyPickView()){
                HStack{
                    Text("내가 채택된 질문")
                        .foregroundStyle(.gray)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: .init(lineWidth: 1) )
                        .foregroundStyle(.gray)
                )
            }
            
            NavigationLink(destination: MyLikeView()){
                HStack{
                    Text("좋아요한 질문")
                        .foregroundStyle(.gray)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.gray)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(style: .init(lineWidth: 1) )
                        .foregroundStyle(.gray)
                )
            }
            
        }
        .padding()
    }
}

#Preview {
    MyPageView()
}
