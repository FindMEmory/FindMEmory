//
//  QuestionRowByKeywordGroup.swift
//  FindMEmory
//
//  Created by 권예원 on 11/17/25.
//

//
//  QuestionRowByKeywordGroup.swift
//  FindMEmory
//
//  Created by 권예원 on 11/17/25.
//

import SwiftUI

struct QuestionItemLink: View {
    let question: Question

    var body: some View {
        let card = QuestionBoxItem(
            image: Image(systemName: "photo"),
            solving: question.is_solved == 1,
            title: question.title,
            heartCount: question.like_count,
            chattingCount: question.answer_count
        )

        NavigationLink(destination: QuestionDetailView()) {
            QuestionBoxItemView(card: card)
        }
    }
}

struct QuestionRowByKeywordGroup: View {
    let keywordId: Int
    let keywordName: String
    
    @State private var questions: [Question] = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("관련 게시글")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink(destination: QuestionListView()) {
                    Text("더보기")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                }

            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 12) {
                    ForEach(questions.prefix(5), id: \.question_id) { q in
                        QuestionItemLink(question: q)   
                    }
                }
            }
        }
        .task {
            fetchQuestionsByKeyword()
        }
    }
    
    func fetchQuestionsByKeyword() {
        guard let url = URL(string:
            "http://127.0.0.1/findmemory/questionByKeyword.php?keyword_id=\(keywordId)"
        ) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(QuestionResponse.self, from: data)
                    DispatchQueue.main.async {
                        self.questions = decoded.data
                    }
                } catch {
                    print("❌ JSON Decode 실패:", error)
                }
            }
        }.resume()
    }
}
