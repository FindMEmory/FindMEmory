//
//  KeywordDetailView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI
import Combine

class KeyboardResponder: ObservableObject {
    @Published var currentHeight: CGFloat = 0
    
    private var cancellableSet: Set<AnyCancellable> = []

    init() {
        let willShow = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification)
            .compactMap { $0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect }
            .map { $0.height }

        let willHide = NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        Publishers.Merge(willShow, willHide)
            .assign(to: \.currentHeight, on: self)
            .store(in: &cancellableSet)
    }
}


struct KeywordDetailView: View {
    
    let keyword : KeywordModel
    var questionCount : Int = 0
    var participantCount : Int = 0
    
    @State var searchKeyword: String = ""
    @StateObject private var keyboard = KeyboardResponder()
    
    var body: some View {
        NavigationStack {
            VStack {
                header
                    .padding(20)
                searchBar
                    .padding(10)
                questionList
                    .padding(10)
                liveChat
            }
            .padding(.bottom, keyboard.currentHeight)
            .padding(.horizontal, 15)
        }
        
    }
    
    var header : some View {
        HStack(spacing: 20){
            Image(systemName: "photo")
                .resizable()
                .frame(width: 80, height: 80)
            VStack(alignment:.leading){
                Text(keyword.name)
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
        
        QuestionRowByKeywordGroup(
            keywordId: keyword.id,
            keywordName: keyword.name
        )


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
    KeywordDetailView(
        keyword: KeywordModel(
            id: 1,
            name: "상속자들",
            created_at: "2025-11-17 10:00:00"
        )
    )
}
