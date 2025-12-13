//
//  QuestionRowListGroup.swift
//  FindMEmory
//
//  Created by 정서영 on 11/10/25.
//

import SwiftUI

struct SortItem {
    let label: String
    let sortKey: String 
}

struct QuestionResponse: Codable {
    let success: Bool
    let sort: String
    let data: [Question]
}

struct MyQuestionResponse: Codable {
    let success: Bool
    let user_id: Int
    let data: [Question]
}

struct Question: Codable, Identifiable, Sendable {
    let question_id: Int
    let author_id: Int
    let body: String
    let keyword_id: Int?
    let answer_count: Int
    let title: String
    let like_count: Int
    let view_count: Int
    let is_solved: Int
    let created_at: String
    let updated_at: String?

    // 🔥 Identifiable을 위한 id → question_id 사용
    var id: Int { question_id }

    // 🔥 JSON에서 디코딩할 키 지정 (id는 제외!)
    enum CodingKeys: String, CodingKey {
        case question_id, author_id, body, keyword_id,
             answer_count, title, like_count, view_count,
             is_solved, created_at, updated_at
    }
}

struct QuestionRowListGroup: View {
    let sortItem: SortItem
    
    @State private var questions: [Question] = []
    
    var body: some View {
        NavigationStack{
            VStack{
                HStack{
                    Text(sortItem.label)
                    
                    Spacer()
                    NavigationLink("더보기") {
                        QuestionListView(sortItem: sortItem)
                    }

                }
                .padding(.horizontal)
                HStack {
                    ForEach(questions.prefix(3), id: \.question_id) { q in
                        QuestionBoxItemView(
                            card: QuestionBoxItem(
                                image: Image(systemName: "photo"),
                                solving: q.is_solved == 1,
                                title: q.title,
                                heartCount: Int(q.like_count),
                                chattingCount: Int(q.answer_count)
                            )
                        )
                    }
                    
                }
            }
            .task {
                fetchQuestions()
            }
        }
    }
    
    func fetchQuestions() {
        guard let url = URL(string: "http://127.0.0.1/findmemory/questionList.php?sort=\(sortItem.sortKey)") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
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
    QuestionRowListGroup(sortItem: SortItem(
        label: "인기 질문",
        sortKey: "like"
    ))
}
