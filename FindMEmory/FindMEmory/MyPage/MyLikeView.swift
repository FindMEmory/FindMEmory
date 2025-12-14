//
//  MyLikeView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct MyLikeView: View {
    @AppStorage("user_id") var userId: Int = 0
    @State private var questions: [Question] = []
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            HeaderGroup
            QuestionListGroup
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .task {
            print("📌 현재 userId =", userId)
            fetchLikedQuestions()
        }
    }
    
    private var HeaderGroup: some View {
        ZStack{
            HStack{
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.backward")
                        .tint(.black)
                })
                Spacer()
            }
            .padding()
            Text("내가 좋아요한 질문")
        }
    }
    
    private var QuestionListGroup: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(questions, id: \.question_id) { q in
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
    
    func fetchLikedQuestions() {
        guard userId != 0 else { return }
        
        guard let url = URL(string:  "http://124.56.5.77/IUI/likeQuestionList.php?user_id=\(userId)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decoded = try JSONDecoder().decode(MyQuestionResponse.self, from: data)
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
    MyLikeView()
}
