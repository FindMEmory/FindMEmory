//
//  QuestionEditView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct QuestionEditView: View {
    @Environment(\.dismiss) private var dismiss

    let questionId: Int
    @State var title: String
    @State var content: String
    
    let onUpdated: () -> Void

    @State private var showAlert = false
    @State private var msg = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {

                // 제목
                TextField("제목", text: $title)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )

                // 내용
                TextEditor(text: $content)
                    .frame(height: 200)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.black, lineWidth: 1)
                    )

                Button {
                    updateQuestion()
                } label: {
                    Text("수정하기")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
            }
            .padding()
        }
        .navigationTitle("질문 수정")
        .navigationBarTitleDisplayMode(.inline)
        .alert("알림", isPresented: $showAlert) {
            Button("확인") {
                if msg == "수정 완료" {
                    onUpdated()
                    dismiss()
                }
            }
        } message: {
            Text(msg)
        }
    }

    // MARK: - 서버 수정
    func updateQuestion() {
        guard let url = URL(string: "http://localhost/findmemory/update_question.php") else { return }

        let params = [
            "question_id": "\(questionId)",
            "title": title,
            "body": content
        ]

        let encoded = params.map {
            "\($0.key)=\($0.value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
        }.joined(separator: "&")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = encoded.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                msg = "수정 완료"
                showAlert = true
            }
        }.resume()
    }
}
