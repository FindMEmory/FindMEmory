//
//  QuestionListView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct QuestionListView: View {

    let sortItem: SortItem?          // 메인 리스트용
    let keywordId: Int?              // 키워드 리스트용
    let keywordName: String?         // 키워드 리스트 타이틀

    @State private var isSolvedFilter: String = "all"
    @State private var questions: [Question] = []

    @Environment(\.dismiss) private var dismiss


    var body: some View {

        NavigationStack {
            VStack {
                HeaderGroup

                if showFilter {
                    FilteringGroup
                }
                QuestionListGroup
                Spacer()
            }
            .navigationBarBackButtonHidden(true)
            .task {
                fetchQuestions()
            }
        }
    }

    // MARK: - Header
    private var HeaderGroup: some View {
        ZStack {
            HStack {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.backward")
                        .tint(.black)
                }
                Spacer()
            }
            .padding()

            Text(headerTitle)
                .font(.headline)
        }
    }

    private var headerTitle: String {
        if let keywordName {
            return keywordName
        } else if let sortItem {
            return sortItem.label
        } else {
            return "질문 목록"
        }
    }

    // MARK: - Filter
    private var showFilter: Bool {
        // 키워드 진입 시 필터 숨김
        guard keywordId == nil else { return false }
        return sortItem?.sortKey != "not_solved"
    }

    private var FilteringGroup: some View {
        HStack {
            Spacer().frame(width: 40)


            Button {
                isSolvedFilter = (isSolvedFilter == "true") ? "all" : "true"
                fetchQuestions()
            } label: {
                filterButton(title: "해결", active: isSolvedFilter == "true")
            }

            Spacer().frame(width: 50)

            Button {
                isSolvedFilter = (isSolvedFilter == "false") ? "all" : "false"
                fetchQuestions()
            } label: {
                filterButton(title: "미해결", active: isSolvedFilter == "false")
            }
            Spacer()
        }
    }

    private func filterButton(title: String, active: Bool) -> some View {
        Text(title)
            .foregroundStyle(.black)
            .padding(.vertical, 3)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .stroke(.gray, lineWidth: 1)
                    .fill(active ? .green : .white)
                    .frame(width: 68)
            )
    }

    // MARK: - List
    private var QuestionListGroup: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(questions) { q in
                    QuestionCardView(
                        card: QuestionCard(
                            id: q.question_id,
                            image: Image(systemName: "photo"),
                            solving: q.is_solved == 1,
                            title: q.title,
                            content: q.body,
                            heartCount: Int(q.like_count),
                            chattingCount: Int(q.answer_count),
                            writer: q.author_id,
                            date: q.created_at
                        )
                    )
                }
            }
        }
    }

    // MARK: - Fetch
    private func fetchQuestions() {
        if let keywordId {
            fetchQuestionsByKeyword(keywordId)
        } else if let sortItem {
            fetchQuestionsBySort(sortItem)
        }
    }

    private func fetchQuestionsBySort(_ sortItem: SortItem) {
        guard let url = URL(
            string: "Question?sort=\(sortItem.sortKey)&isSolved=\(isSolvedFilter)"
        ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data {
                do {
                    let decoded = try JSONDecoder().decode(QuestionResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.questions = decoded.data
                    }
                } catch {
                    print("Decode 실패:", error)
                }
            }
        }.resume()
    }

    private func fetchQuestionsByKeyword(_ keywordId: Int) {
        guard let url = URL(
            string: "questionByKeyword.php?keyword_id=\(keywordId)"
        ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data {
                do {
                    let decoded = try JSONDecoder().decode(QuestionResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.questions = decoded.data
                    }
                } catch {
                    print("Decode 실패:", error)
                }
            }
        }.resume()
    }
}

#Preview {

    QuestionListView(
        sortItem: SortItem(label: "인기 질문", sortKey: "like"),
        keywordId: nil,
        keywordName: nil
    )
}

