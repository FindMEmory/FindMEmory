//
//  SearchView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchContent: String = ""
    @State private var popularKeywordList: [KeywordModel] = []
    
    var body: some View {
        NavigationStack{
            HeaderGroup
            TextField("검색", text: $searchContent)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                )
                .padding(.horizontal, 10)
            KeywordCardGroup
            QuestionGroup
        }
        .task {
            fetchKeywords(sort: "popular")
        }
    }
    
    private var HeaderGroup: some View {
        HStack{
            Text("FindMEmory")
                .bold()
            Spacer()
            NavigationLink(destination: NotificationView()){
                Image(systemName: "bell")
                    .tint(.black)
            }
        }
        .padding()
    }
    
    private var KeywordCardGroup: some View {
        VStack(alignment: .leading){
            Text("인기 키워드 카드")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(popularKeywordList) { item in
                        NavigationLink(
                            destination: KeywordDetailView(keyword: item)
                        ) {
                            Keyword(
                                keywordName: item.name,
                                questionCount: item.question_count,
                                participantCount: item.participant_count
                            )
                        }
                    }
                }
            }
        }
        .padding()
    }
    
    private var QuestionGroup: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("게시글")
            
        }
    }
    
    func fetchKeywords(sort: String) {
        guard let url = URL(
            string: "http://127.0.0.1/findmemory/get_keyword.php?sort=\(sort)"
        ) else {
            print("URL Error")
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("요청 에러:", error)
                return
            }

            guard let data = data else {
                print("데이터 없음")
                return
            }

            do {
                let response = try JSONDecoder()
                    .decode(KeywordListResponse.self, from: data)
                DispatchQueue.main.async {
                    if response.success {
                        if sort == "popular" {
                            self.popularKeywordList = response.keywords
                        }
                    }
                    print(popularKeywordList)
                }
            } catch {
                print("디코딩 오류:", error)
            }

        }.resume()
    }
}

#Preview {
    SearchView()
}
