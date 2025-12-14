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
        let card = QuestionBoxItem( // 질문 데이터를 카드 UI 모델로 변환
            id: question.id,
            image: Image(systemName: "photo"),
            solving: question.is_solved == 1,
            title: question.title,
            heartCount: question.like_count,
            chattingCount: question.answer_count
        )

        NavigationLink(destination: QuestionDetailView(questionId: question.question_id)) { // 질문 선택 시 상세 화면으로 이동
            QuestionBoxItemView(card: card)
        }
    }
}

struct QuestionRowByKeywordGroup: View {
    let keywordId: Int // 현재 키워드 ID
    let keywordName: String // 키워드 이름
    let searchText: String // 검색어 <- 상위 뷰(KeywordDetailView)에서 전달
    
    @State private var questions: [Question] = [] // 조회된 질문 목록
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("관련 게시글")
                    .font(.headline)
                
                Spacer()
                
                NavigationLink(destination:QuestionListView( // 전체 질문 목록으로 이동
                    sortItem: nil,
                    keywordId: keywordId,
                    keywordName: keywordName,
                    searchKeyword: nil
                )) {
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
        .task(id: searchText) { // 검색어 변경될 때마다 재조회
            fetchQuestionsByKeyword()
        }

    }
    
    func fetchQuestionsByKeyword() {
        let encoded = searchText // 검색어 URL 인코딩 처리 -> 문자열 깨짐 방지
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let urlString =
        "http://124.56.5.77/IUI/questionByKeyword.php?keyword_id=\(keywordId)&search=\(encoded)"

        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            if let data {
                do {
                    let decoded = try JSONDecoder().decode(QuestionResponse.self, from: data) // JSON 디코딩
                    DispatchQueue.main.async { // 메인 스레드에서 질문 목록 상태 갱신
                        self.questions = decoded.data
                    }
                } catch {
                    print("JSON Decode 실패:", error)
                }
            }
        }.resume()
    }

}
