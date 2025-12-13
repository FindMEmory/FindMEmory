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

                .padding(.horizontal)
            }
        }
    }

    // MARK: - UI Components

    private var userGroup: some View {
        HStack {
            Image(.profile)

            VStack(alignment: .leading) {

                Text("닉네임")
                Text("dafj")
            }
            .foregroundStyle(.gray)

            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)

                .stroke(.gray, lineWidth: 1)
        )
        .padding(.horizontal)
    }

    private var gradeGroup: some View {
        VStack(alignment: .leading) {
            Text("나의 등급")

            VStack(alignment: .leading) {

                Text("다음 등급까지 채택 4개")
                    .foregroundStyle(.gray)
                Image(.grade)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
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

    }
}

#Preview {
    MyPageView()
}
