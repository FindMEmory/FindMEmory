//
//  KeywordPickerSheet.swift
//  FindMEmory
//
//  Created by 권예원 on 12/13/25.
//

import SwiftUI

struct KeywordPickerSheet: View {
    @Binding var selectedKeyword: KeywordModel?
    let onComplete: (KeywordModel) -> Void

    @State private var query: String = ""
    @State private var keywords: [KeywordModel] = []
    @State private var selected: KeywordModel? = nil

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // ── 상단 영역
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

                // ── 검색 결과 리스트
                VStack(spacing: 0) {
                    ForEach(keywords) { keyword in
                        HStack {
                            Image(.keyword)
                                .foregroundColor(.gray)

                            Text(keyword.name)

                            Spacer()

                            Text("\(keyword.question_count)개의 질문")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 20)
                        .padding(.vertical, 14)
                        .background(
                            selected?.id == keyword.id
                            ? Color.gray.opacity(0.15)
                            : Color.clear
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selected = keyword
                        }
                    }
                }
                .padding(.top, 10)

                HStack {
                    Spacer()
                    NavigationLink {
                        CreateKeywordView { newKeyword in
                            selected = newKeyword
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

                if let selected {
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

    // ── 검색 API
    private func searchKeywords() {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            keywords = []
            return
        }

        let encoded = trimmed.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        guard let url = URL(
            string: "http://127.0.0.1/findmemory/search_keyword.php?query=\(encoded)"
        ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else { return }
            do {
                let decoded = try JSONDecoder().decode(KeywordListResponse.self, from: data)
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

//#Preview {
//    KeywordPickerSheet(
//        selectedKeyword: .constant(
//            KeywordModel(
//                id: 1,
//                name: "상속",
//                created_at: ""
//            )
//        )
//    )
//}
