//
//  QuestionListView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct QuestionListView: View {
    let sortItem: SortItem
    @State private var questions: [Question] = []
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack{
            HeaderGroup
            FilteringGroup
            QuestionListGroup
            Spacer()
        }
        .task {
            fetchQuestions()
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
            Text(sortItem.label)
        }
    }
    
    private var FilteringGroup: some View {
        HStack{
            Spacer().frame(width: 40)
            Button(action: {}, label: {
                Text("해결")
                    .foregroundStyle(.black)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.gray, lineWidth: 1)
                            .frame(width: 68)
                    )
            })
            Spacer().frame(width: 50)
            Button(action: {}, label: {
                Text("미해결")
                    .foregroundStyle(.black)
                    .padding(.vertical, 3)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(.gray, lineWidth: 1)
                            .frame(width: 68)
                    )
            })
            Spacer()
        }
    }
    
    private var QuestionListGroup: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(questions, id: \.question_id) { q in
                    QuestionCardView(
                        card: QuestionCard(
                            image: Image(systemName: "photo"),
                            solving: q.is_solved == "1",
                            title: q.title,
                            content: q.body,
                            heartCount: Int(q.like_count) ?? 0,
                            chattingCount: Int(q.answer_count) ?? 0,
                            writer: q.author_id,
                            date: q.created_at
                        )
                    )
                }
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
