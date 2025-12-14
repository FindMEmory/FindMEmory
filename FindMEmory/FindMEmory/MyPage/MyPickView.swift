//
//  MyPickView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct MyPickView: View {
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
            Text("내가 채택된 질문")
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

        let url = URL(string:
            "http://127.0.0.1/findmemory/acceptedQuestionList.php?user_id=\(userId)"
        )!

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            do {
                let decoded = try JSONDecoder()
                    .decode(AcceptedQuestionResponse.self, from: data)

                DispatchQueue.main.async {
                    self.questions = decoded.data
                }
            } catch {
                print("❌ Decode 실패:", error)
            }
        }.resume()
    }

}

#Preview {
    MyPickView()
}
