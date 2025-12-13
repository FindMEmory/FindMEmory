//
//  MyPageView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct MyPageView: View {
    @AppStorage("user_id") private var userId: Int = 0
    @AppStorage("is_logged_in") private var isLoggedIn: Bool = true

    var body: some View {
<<<<<<< HEAD
        NavigationStack {
            VStack(spacing: 30) {

                // ---------- 상단 ----------
                HStack {
                    Text("계정 정보")
                        .font(.headline)

                    Spacer()

                    NavigationLink(destination: NotificationView()) {
                        Image(systemName: "bell")
                            .foregroundStyle(.black)
                    }
                }
                .padding(.top, 50)
                .padding(.horizontal)

                // ---------- 유저 정보 ----------
                NavigationLink(destination: EditUserPageView()) {
                    userGroup
                }

                // ---------- 등급 ----------
                gradeGroup

                // ---------- 질문 그룹 ----------
                questionsGroup

                Spacer()

                // ---------- 로그아웃 ----------
                Button(action: logout) {
                    Text("로그아웃")
                        .foregroundStyle(.gray)
                        .frame(maxWidth: .infinity, maxHeight: 45)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(.gray, lineWidth: 1)
                        )
                }
=======
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
>>>>>>> c53dc73 (✨Feat: 게시글 키워드 카드검색, 등록 및 키워드 카드 참여자수, 게시글 수 기능 추가)
                .padding(.horizontal)
            }
        }
    }
<<<<<<< HEAD

    // MARK: - UI Components

    private var userGroup: some View {
        HStack {
            Image(.profile)

            VStack(alignment: .leading) {
=======
    
    private var UserGroup : some View {
        HStack{
            Image(.profile)
            VStack (alignment: .leading){
>>>>>>> c53dc73 (✨Feat: 게시글 키워드 카드검색, 등록 및 키워드 카드 참여자수, 게시글 수 기능 추가)
                Text("닉네임")
                Text("dafj")
            }
            .foregroundStyle(.gray)
<<<<<<< HEAD

=======
>>>>>>> c53dc73 (✨Feat: 게시글 키워드 카드검색, 등록 및 키워드 카드 참여자수, 게시글 수 기능 추가)
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
<<<<<<< HEAD
                .stroke(.gray, lineWidth: 1)
        )
        .padding(.horizontal)
    }

    private var gradeGroup: some View {
        VStack(alignment: .leading) {
            Text("나의 등급")

            VStack(alignment: .leading) {
=======
                .stroke(style: .init(lineWidth: 1) )
                .foregroundStyle(.gray)
        )
        .padding(.horizontal)
    }
    
    private var GradeGroup : some View {
        VStack(alignment: .leading){
            Text("나의 등급")
            VStack(alignment: .leading){
>>>>>>> c53dc73 (✨Feat: 게시글 키워드 카드검색, 등록 및 키워드 카드 참여자수, 게시글 수 기능 추가)
                Text("다음 등급까지 채택 4개")
                    .foregroundStyle(.gray)
                Image(.grade)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
<<<<<<< HEAD
                    .stroke(.gray, lineWidth: 1)
            )
        }
        .padding(.horizontal)
    }

    private var questionsGroup: some View {
        VStack(spacing: 12) {
            NavigationLink(destination: MyAskView()) {
                row(title: "내가 등록한 질문")
            }

            NavigationLink(destination: MyPickView()) {
                row(title: "내가 채택된 질문")
            }

            NavigationLink(destination: MyLikeView()) {
                row(title: "좋아요한 질문")
            }
        }
        .padding(.horizontal)
    }

    private func row(title: String) -> some View {
        HStack {
            Text(title)
                .foregroundStyle(.gray)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(.gray)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 1)
        )
    }

    private func logout() {
        print("로그아웃 버튼 눌림")
        userId = 0
        isLoggedIn = false
        print("isLoggedIn:", isLoggedIn)
=======
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
>>>>>>> c53dc73 (✨Feat: 게시글 키워드 카드검색, 등록 및 키워드 카드 참여자수, 게시글 수 기능 추가)
    }
}

#Preview {
    MyPageView()
}
