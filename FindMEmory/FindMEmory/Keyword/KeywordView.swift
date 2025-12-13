//
//  KeywordView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct KeywordView: View {

    @State private var keywordQuery: String = ""

    @State private var popularKeywordList: [KeywordModel] = []
    @State private var recentKeywordList: [KeywordModel] = []

    private let gridColumns = [
        GridItem(.flexible(), spacing: 15),
        GridItem(.flexible(), spacing: 15)
    ]

    var body: some View {
        NavigationStack {
            VStack {
                searchBar
                    .padding(.bottom, 10)

                createKeywordButton
                    .padding(.bottom, 10)

                if isSearching {
                    searchResultSection
                } else {
                    popularKeywordSection
                        .padding(.bottom, 40)

                    recentKeywordSection
                }

                Spacer()
            }
            .padding(.horizontal, 15)
            .onAppear {
                fetchKeywords(sort: "popular")
                fetchKeywords(sort: "recent")
            }
        }
    }

    // MARK: - 검색 상태
    var isSearching: Bool {
        !keywordQuery.isEmpty
    }

    // MARK: - 검색 결과 (popular + recent 합침)
    var searchedKeywordList: [KeywordModel] {
        let combined = popularKeywordList + recentKeywordList

        // id 기준 중복 제거
        let unique = Dictionary(grouping: combined, by: { $0.id })
            .compactMap { $0.value.first }

        return unique.filter {
            $0.name.localizedCaseInsensitiveContains(keywordQuery)
        }
    }

    // MARK: - API
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
                        } else if sort == "recent" {
                            self.recentKeywordList = response.keywords
                        }
                    }
                }
            } catch {
                print("디코딩 오류:", error)
            }

        }.resume()
    }

    // MARK: - Search Bar
    var searchBar: some View {
        TextField("검색", text: $keywordQuery)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            )
    }

    // MARK: - Create Button
    var createKeywordButton: some View {
        HStack {
            Spacer()
            NavigationLink(destination: CreateKeywordView { _ in }) {
                Text("+ 키워드 카드 만들기")
                    .foregroundColor(.black)
            }
        }
    }

    // MARK: - 인기 키워드
    var popularKeywordSection: some View {
        VStack(alignment: .leading, spacing: 15) {
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
    }

    // MARK: - 최근 키워드
    var recentKeywordSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("최근 키워드 카드")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(recentKeywordList) { item in
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
    }


    var searchResultSection: some View {
        VStack(alignment: .leading, spacing: 15) {

            if searchedKeywordList.isEmpty {
                Text("검색 결과가 없습니다.")
                    .foregroundColor(.gray)
                    .padding(.top, 20)
            } else {
                ScrollView {
                    LazyVGrid(columns: gridColumns, spacing: 20) {
                        ForEach(searchedKeywordList) { item in
                            NavigationLink(
                                destination: KeywordDetailView(keyword: item)
                            ) {
                                Keyword(
                                    keywordName: item.name,
                                    questionCount: item.question_count,
                                    participantCount: item.participant_count
                                )
                                .frame(maxWidth: .infinity)
                            }
                        }
                    }
                    .padding(.top, 10)
                }
            }
        }
    }
}

#Preview {
    KeywordView()
}
