//
//  KeywordPickerSheet.swift
//  FindMEmory
//
//  Created by 권예원 on 12/13/25.
//

import SwiftUI

struct KeywordPickerSheet: View {
    @Binding var selectedKeyword: KeywordModel? // 상위 뷰(AddQuestionView)와 선택된 키워드 공유하기 위한 바인딩 값
    let onComplete: (KeywordModel) -> Void // 키워드 선택 완료 시 콜백 함수

    @State private var query: String = "" //키워드 검색어
    @State private var keywords: [KeywordModel] = [] // 조회된 키워드 카드 목록
    @State private var selected: KeywordModel? = nil // 선택된 키워드 카드

    @Environment(\.dismiss) private var dismiss // 시트를 닫기 위한 변수

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                VStack(alignment: .leading, spacing: 20) {

                    HStack(spacing: 8) {
                        Image(.keyword)
                        Text("키워드 카드 등록하기")
                            .font(.headline)
                    }

                    HStack {
                        TextField("키워드 찾아보기", text: $query)
                            .submitLabel(.search)
                            .onSubmit {
                                searchKeywords()
                            }

                        Button {
                            searchKeywords()
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(.black)
                        }
                    }
                    .padding(12)
                    .background(
                        RoundedRectangle(cornerRadius: 22)
                            .stroke(.black, lineWidth: 1)
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)

                VStack(spacing: 0) {
                    ForEach(keywords) { keyword in
                        HStack {
                            Image(.keyword)
                                .foregroundColor(.gray)

                            Text(keyword.name)

                            Spacer()

                            Text("\(keyword.question_count)개의 질문") // 해당 키워드 질문 수 표시
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background( // 선택됐을 때 배경 색상 적용
                            selected?.id == keyword.id
                            ? Color.gray.opacity(0.15)
                            : Color.clear
                        )
                        .contentShape(Rectangle()) // 빈 영역도 터치 가능
                        .onTapGesture {
                            selected = keyword // 키워드 카드 선택 처리
                        }
                    }
                }
                .padding(.top, 10)

                HStack {
                    Spacer()
                    NavigationLink {
                        CreateKeywordView { newKeyword in
                            selected = newKeyword // 새로운 키워드 선택 상태로 설정
                        }
                    } label: {
                        Text("+ 새로운 키워드 카드 만들기")
                            .font(.footnote)
                            .foregroundColor(.black)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                Spacer()

                if let selected { // 키워드 카드 선택된 경우에만 확인 버튼 표시
                    Button {
                        selectedKeyword = selected
                        onComplete(selected)
                        dismiss()
                    } label: {
                        Text("확인")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.black)
                            .cornerRadius(24)
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }

    private func searchKeywords() {
        let trimmed = query.trimmingCharacters(in: .whitespaces) // 검색어 앞뒤 공백 제거
        guard !trimmed.isEmpty else { // 검색어 비어있으면 초기화
            keywords = []
            return
        }

        let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" // 검색어 URL 인코딩 -> 깨짐 방지
        guard let url = URL(
            string: "http://124.56.5.77/IUI/search_keyword.php?query=\(encoded)"
        ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else { return }
            do {
                let decoded = try JSONDecoder().decode(KeywordListResponse.self, from: data) // JSON 디코딩
                DispatchQueue.main.async {
                    self.keywords = decoded.keywords
                }
            } catch {
                print("키워드 검색 실패:", error)
            }
        }.resume()
    }
}


#Preview {
    KeywordPickerSheet(
        selectedKeyword: .constant(nil)
    ){_ in }
}

