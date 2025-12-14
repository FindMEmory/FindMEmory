//
//  HomeView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct HomeView: View {
    @AppStorage("user_id") private var loginUserId: Int = 0
    @State private var nickname: String = ""
    
    var body: some View {
        NavigationStack{
            ScrollView{
                HeaderGroup
                    .padding(.horizontal)
                GoWriteGroup
                    .padding(.horizontal)
                QuestionRowListGroup(sortItem: SortItem(
                    label: "인기 질문",
                    sortKey: "like"
                ))

                QuestionRowListGroup(sortItem: SortItem(
                    label: "최근 질문",
                    sortKey: "date"
                ))

                QuestionRowListGroup(sortItem: SortItem(
                    label: "답변을 기다리고 있어요",
                    sortKey: "not_solved"
                ))
            }}
        .task{fetchUserInfo()}
    }
    
    private var HeaderGroup: some View {
        HStack{
            Text("FindMemory")
                .font(.largeTitle)
                .bold()
            Spacer()
            NavigationLink(destination: NotificationView()){
                Image(systemName: "bell")
                    .resizable()
                    .frame(width: 27, height: 27)
                    .foregroundStyle(.black)
            }
        }
        .padding()
    }
    
    private var GoWriteGroup: some View {
        VStack(alignment: .leading){
            HStack(spacing: 0) {
                  Text(nickname)
                  Text("님,")
              }
                .font(.headline)
                .bold()
            Text("오늘은 어떤 기억을 떠올렸나요?")
                .font(.headline)
                .bold()
            NavigationLink("글 작성하러가기", destination: AddQuestionView())
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.gray)
                )
        }
        .padding(.horizontal, 10)
        .padding(.vertical)
    }
    
    private func fetchUserInfo() {
        guard let url = URL(
            string: "http://localhost/findmemory/get_user.php?user_id=\(loginUserId)"
        ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else { return }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               json["success"] as? Bool == true {
                DispatchQueue.main.async {
                    nickname = json["nickname"] as? String ?? ""
                }
            }
        }.resume()
    }
}

#Preview {
    HomeView()
}
