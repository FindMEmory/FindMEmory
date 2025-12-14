//
//  KeywordDetailView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI
import Combine

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0 // 현재 키보드 높이 저장
    private var cancellableSet: Set<AnyCancellable> = [] // Combine 구독 저장 Set

    init() {
        let willShow = NotificationCenter.default // 키보드가 나타날 때 알림 퍼블리셔
            .publisher(for: UIResponder.keyboardWillShowNotification) // 키보드 나타나는 시스템 알림 감지
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect } // 키보드 프레임 추출
            .map { $0.height } // 키보드 높이 사용

        let willHide = NotificationCenter.default // 키보드가 사라질 때 알림 퍼블리셔
            .publisher(for: UIResponder.keyboardWillHideNotification) // 키보드 사라지는 시스템 알림 감지
            .map { _ in CGFloat(0) } // 높이 0으로 설정

        Publishers.Merge(willShow, willHide)
            .assign(to: \.currentHeight, on: self) // 키보드 높이 반영
            .store(in: &cancellableSet) // 구독 저장
    }
}

struct KeywordDetailView: View {

    let keyword: KeywordModel

    @StateObject private var keyboard = KeyboardResponder() // 키보드 높이 변화 감지 객체
    @State private var searchText: String = "" // 질문 검색어

    var body: some View {
        NavigationStack {
            VStack {
                header
                    .padding(20)

                searchBar
                    .padding(.horizontal, 10)

                questionList
                    .padding(.top, 10)

                liveChat
            }
            .padding(.bottom, keyboard.currentHeight)
            .padding(.horizontal, 15)
        }
    }

    private var header: some View {
        HStack(spacing: 20) {
            Image(systemName: "photo")
                .resizable()
                .frame(width: 80, height: 80)

            VStack(alignment: .leading) {
                Text(keyword.name)
                    .font(.system(size: 20, weight: .bold))

                Text("게시글 \(keyword.question_count)") // 질문 수
                Text("현재 \(keyword.participant_count)명 참여중") // 참여자 수
            }
            .font(.system(size: 15))
            .foregroundStyle(.gray)

            Spacer()
        }
    }


    private var searchBar: some View {
        TextField("검색", text: $searchText)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(.gray, lineWidth: 1)
            )
    }

    private var questionList: some View {
        QuestionRowByKeywordGroup(
            keywordId: keyword.id,
            keywordName: keyword.name,
            searchText: searchText
        )
    }

    private var liveChat: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("실시간 채팅")
                .font(.headline)

            ChatSection(keywordId: keyword.id)
                .background(Color.gray.opacity(0.1))
        }
    }
}


#Preview {
    KeywordDetailView(
        keyword: KeywordModel(
            id: 1,
            name: "상속자들",
            question_count: 12,
            created_at: "2025-11-17 10:00:00",
            participant_count: 5
        )
    )
}
