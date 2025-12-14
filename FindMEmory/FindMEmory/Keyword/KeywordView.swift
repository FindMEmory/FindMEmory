//
//  KeywordView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct KeywordView: View {

    @State private var keywordQuery: String = "" // 키워드 검색어

    @State private var popularKeywordList: [KeywordModel] = [] // 인기 키워드 목록
    @State private var recentKeywordList: [KeywordModel] = [] // 최근 키워드 목록

    private let gridColumns = [ // 검색 결과 표시용 2열 그리드
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

                if isSearching { // 검색어가 입력된 상태면
                    searchResultSection
                } else { // 검색어가 없으면
                    popularKeywordSection
                        .padding(.bottom, 40)

                    recentKeywordSection
                }

                Spacer()
            }
            .padding(.horizontal, 15)
            .onAppear { // 화면 진입 시 키워드 목록 조회
                fetchKeywords(sort: "popular")
                fetchKeywords(sort: "recent")
            }
        }
    }

    var isSearching: Bool {
        !keywordQuery.isEmpty
    }

    var searchedKeywordList: [KeywordModel] {
        let combined = popularKeywordList + recentKeywordList // 두 목록을 하나로 합침

        let unique = Dictionary(grouping: combined, by: { $0.id }) // id 기준 중복 제거
            .compactMap { $0.value.first }

        return unique.filter {
            $0.name.localizedCaseInsensitiveContains(keywordQuery) // 검색어 포함 키워드만 필터링
        }
    }

    func fetchKeywords(sort: String) { // 정렬 기준 전달

        guard let url = URL(
            string: "http://124.56.5.77/IUI/get_keyword.php?sort=\(sort)"
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
                    .decode(KeywordListResponse.self, from: data) // JSON 디코딩

                DispatchQueue.main.async {
                    if response.success {
                        if sort == "popular" { // 인기 키워드 목록 갱신
                            self.popularKeywordList = response.keywords
                        } else if sort == "recent" { // 최근 키워드 목록 갱신
                            self.recentKeywordList = response.keywords
                        }
                    }
                }
            } catch {
                print("디코딩 오류:", error)
            }

        }.resume()
    }

    var searchBar: some View {
        TextField("검색", text: $keywordQuery)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 1)
            )
    }

    var createKeywordButton: some View {
        HStack {
            Spacer()
            NavigationLink(destination: CreateKeywordView { _ in }) {
                Text("+ 키워드 카드 만들기")
                    .foregroundColor(.black)
            }
        }
    }

    // 인기 키워드 카드 표시
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

    // 최근 키워드 카드 표시
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

    // 검색 결과
    var searchResultSection: some View {
        VStack(alignment: .leading, spacing: 15) {

            if searchedKeywordList.isEmpty { // 검색어에 맞는 결과가 없으면
                Text("검색 결과가 없습니다.")
                    .foregroundColor(.gray)
                    .padding(.top, 20)
            } else {
                ScrollView {
                    LazyVGrid(columns: gridColumns, spacing: 20) { // 결과 있으면 그리드 형태로 표시
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
