//
//  QuestionDetailView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct QuestionDetailView: View {
    @AppStorage("user_id") var userId: Int = 0

    let questionId: Int

    @State private var questionTitle = ""
    @State private var questionBody = ""
    @State private var questionNickname = ""
    @State private var questionDate = ""
    @State private var questionAuthorId = 0

    @State private var likeCount = 0
    @State private var acceptedCommentId: Int? = nil

    @State private var comments: [Comment] = []
    @State private var commentText = ""
    
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // ---------------- NAV BAR ----------------
                HStack {
                    Spacer()

                    if questionAuthorId == userId {
                        Menu {
                            NavigationLink(destination: QuestionEditView()) {
                                Text("수정")
                            }
                            Button("삭제", role: .destructive) {
                                deleteQuestion()
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                                .foregroundColor(.black)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 10)

                Divider()

                // ---------------- CONTENT ----------------
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        // 작성자 정보
                        HStack {
                            Circle()
                                .fill(Color.gray.opacity(0.3))
                                .frame(width: 40, height: 40)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(questionNickname)
                                    .font(.system(size: 15, weight: .semibold))
                                Text(questionDate)
                                    .font(.system(size: 12))
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            Text("B")
                                .font(.system(size: 12, weight: .bold))
                                .padding(6)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(Circle())
                        }

                        // 제목 + 내용
                        Text(questionTitle)
                            .font(.system(size: 18, weight: .bold))

                        Text(questionBody)
                            .font(.system(size: 15))
                            .lineSpacing(4)

                        // 이미지 (임시)
                        HStack(spacing: 8) {
                            ForEach(0..<3) { _ in
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 100, height: 100)
                            }
                        }

                        // 좋아요 + 댓글 카운트
                        HStack(spacing: 12) {
                            Button {
                                likeQuestion()
                            } label: {
                                Label("\(likeCount)", systemImage: "heart.fill")
                                    .foregroundColor(.red)
                            }

                            Label("댓글 \(comments.count)", systemImage: "text.bubble")
                                .foregroundColor(.gray)

                            Spacer()
                        }
                        .font(.system(size: 14, weight: .medium))

                        Divider()

                        // ---------------- 댓글 목록 ----------------
                        VStack(spacing: 12) {
                            // 채택된 댓글 먼저 표시
                            ForEach(comments.filter { $0.id == acceptedCommentId }) { comment in
                                CommentRow(
                                    comment: comment,
                                    isQuestionOwner: questionAuthorId == userId,
                                    onAccept: { acceptComment(comment.id) },
                                    onDelete: { deleteComment(comment.id) }
                                )
                            }

                            // 나머지 댓글
                            ForEach(comments.filter { $0.id != acceptedCommentId }) { comment in
                                CommentRow(
                                    comment: comment,
                                    isQuestionOwner: questionAuthorId == userId,
                                    onAccept: { acceptComment(comment.id) },
                                    onDelete: { deleteComment(comment.id) }
                                )
                            }
                        }
                    }
                    .padding()
                }

                // ---------------- 댓글 입력 ----------------
                HStack {
                    TextField("댓글을 입력하세요.", text: $commentText)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)

                    Button {
                        if !commentText.isEmpty {
                            addCommentToServer()
                        }
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(.white)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
        }
        .onAppear {
            loadDetail()
        }
    }

    // ----------------------------------------------------
    // 서버 통신
    // ----------------------------------------------------

    func loadDetail() {
        guard let url = URL(string: "http://localhost/findmemory/get_detail.php?id=\(questionId)") else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else { return }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {

                if let q = json["question"] as? [String: Any] {
                    DispatchQueue.main.async {
                        questionTitle = q["title"] as? String ?? ""
                        questionBody = q["body"] as? String ?? ""
                        questionNickname = q["nickname"] as? String ?? ""
                        questionDate = q["created_at"] as? String ?? ""
                        questionAuthorId = q["author_id"] as? Int ?? 0

                        acceptedCommentId = q["accepted_comment_id"] as? Int
                        likeCount = q["like_count"] as? Int ?? 0
                    }
                }

                if let arr = json["comments"] as? [[String: Any]] {
                    DispatchQueue.main.async {
                        comments = arr.map {
                            Comment(
                                id: $0["id"] as? Int ?? 0,
                                authorId: $0["author_id"] as? Int ?? 0,
                                nickname: $0["nickname"] as? String ?? "",
                                text: $0["text"] as? String ?? "",
                                date: $0["created_at"] as? String ?? ""
                            )
                        }
                    }
                }
            }
        }
        .resume()
    }

    // 좋아요 ----------------------------------------------------

    func likeQuestion() {
        guard let url = URL(string: "http://localhost/findmemory/like_question.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "question_id=\(questionId)&user_id=\(userId)".data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }
            print("좋아요 응답:", String(data: data, encoding: .utf8)!)

            DispatchQueue.main.async {
                loadDetail()
            }
        }.resume()
    }

    // 댓글 등록 ----------------------------------------------------

    func addCommentToServer() {
        guard let url = URL(string: "http://localhost/findmemory/add_answer.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")

        let params: [String: Any] = [
            "question_id": questionId,
            "author_id": userId,
            "body": commentText
        ]

        var form = ""
        for (key, value) in params {
            if !form.isEmpty { form += "&" }
            let encodedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            form += "\(key)=\(encodedValue)"
        }

        request.httpBody = form.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else { return }

            if let res = String(data: data, encoding: .utf8) {
                print("댓글 등록 응답 → \(res)")
            }

            DispatchQueue.main.async {
                commentText = ""
                loadDetail()
            }
        }.resume()
    }

    // 댓글 채택 ----------------------------------------------------

    func acceptComment(_ id: Int) {
        guard let url = URL(string: "http://localhost/findmemory/accept_answer.php") else { return }

        let params = "answer_id=\(id)&question_id=\(questionId)"

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = params.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                acceptedCommentId = id
                loadDetail()
            }
        }.resume()
    }

    // 댓글 삭제 ----------------------------------------------------

    func deleteComment(_ id: Int) {
        guard let url = URL(string: "http://localhost/findmemory/delete_answer.php") else { return }

        let params = "answer_id=\(id)"

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = params.data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                loadDetail()
            }
        }.resume()
    }

    // 질문 삭제 ----------------------------------------------------

    func deleteQuestion() {
        guard let url = URL(string: "http://localhost/findmemory/delete_question.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "question_id=\(questionId)".data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            if let data = data {
                print("질문 삭제 응답:", String(data: data, encoding: .utf8)!)
            }

            DispatchQueue.main.async {
                dismiss()   // 삭제 완료 → 메인으로 이동
            }
        }.resume()
    }
}


// ----------------------------------------------------
// COMMENT MODEL + ROW
// ----------------------------------------------------

struct Comment: Identifiable {
    let id: Int
    let authorId: Int
    let nickname: String
    let text: String
    let date: String
}

struct CommentRow: View {
    let comment: Comment

    let isQuestionOwner: Bool
    let onAccept: () -> Void
    let onDelete: () -> Void

    @AppStorage("user_id") var userId: Int = 0
    var isMine: Bool { comment.authorId == userId }

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 32, height: 32)

                VStack(alignment: .leading) {
                    HStack(spacing: 4) {
                        Text(comment.nickname)
                            .font(.system(size: 14, weight: .semibold))

                        Text("B")
                            .font(.system(size: 11, weight: .bold))
                            .padding(4)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }

                    Text(comment.text)
                        .font(.system(size: 14))
                }

                Spacer()

                if isQuestionOwner {
                    if isMine {
                        Button("삭제하기") { onDelete() }
                            .font(.system(size: 12))
                            .padding(6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    } else {
                        Button("채택하기") { onAccept() }
                            .font(.system(size: 12))
                            .padding(6)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(6)
                    }
                }
            }

            Text(comment.date)
                .font(.system(size: 11))
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    QuestionDetailView(questionId: 9)
}
