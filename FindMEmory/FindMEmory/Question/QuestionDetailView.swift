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

    // 게시글 정보
    @State private var questionTitle = ""
    @State private var questionBody = ""
    @State private var questionNickname = ""
    @State private var questionDate = ""
    @State private var questionAuthorId = 0

    @State private var likeCount = 0
    @State private var isLiked = false
    @State private var acceptedCommentId: Int? = nil

    // 댓글
    @State private var comments: [Comment] = []
    @State private var commentText = ""

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // ---------- 상단 메뉴 ----------
                HStack {
                    Spacer()

                    if questionAuthorId == userId {
                        Menu {
                            NavigationLink("수정") {
<<<<<<< HEAD
                                QuestionEditView(
                                    questionId: questionId,
                                    title: questionTitle,
                                    content: questionBody,
                                    onUpdated: {
                                        loadDetail()
                                    }
                                )
                            }

=======
                                QuestionEditView()
                            }
>>>>>>> c53dc73 (✨Feat: 게시글 키워드 카드검색, 등록 및 키워드 카드 참여자수, 게시글 수 기능 추가)
                            Button("삭제", role: .destructive) {
                                deleteQuestion()
                            }
                        } label: {
                            Image(systemName: "ellipsis")
                                .rotationEffect(.degrees(90))
                                .foregroundColor(.black)
                        }
                    }
<<<<<<< HEAD

=======
>>>>>>> c53dc73 (✨Feat: 게시글 키워드 카드검색, 등록 및 키워드 카드 참여자수, 게시글 수 기능 추가)
                }
                .padding(.horizontal)
                .padding(.vertical, 10)

                Divider()
                
                // ---------- 본문 ----------
                ScrollView {
                    VStack(spacing: 0) {

                        // 게시글 영역
                        QuestionPostSection(
                            questionTitle: questionTitle,
                            questionBody: questionBody,
                            questionNickname: questionNickname,
                            questionDate: questionDate,
                            likeCount: likeCount,
                            isLiked: isLiked,
                            onLikeTap: likeQuestion,
                            commentCount: comments.count
                        )
                        .padding()

                        // 댓글 영역
                        QuestionCommentSection(
                            comments: comments,
                            acceptedCommentId: acceptedCommentId,
                            isQuestionOwner: questionAuthorId == userId,
                            onAccept: acceptComment,
                            onDelete: deleteComment,
                            commentText: $commentText,
                            onSend: {
                                if !commentText.isEmpty {
                                    addCommentToServer()
                                }
                            }
                        )
                    }
                }
            }
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            loadDetail()
        }
    }

    // ----------------------------------------------------
    // MARK: - 서버 통신
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

                        likeCount = q["like_count"] as? Int ?? 0
                        acceptedCommentId = q["accepted_comment_id"] as? Int
                        isLiked = q["is_liked"] as? Bool ?? false
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
                                date: $0["created_at"] as? String ?? "",
                                isAccepted: ($0["is_accepted"] as? Bool) ?? false
                            )
                        }
                    }
                }
            }
        }.resume()
    }

    // 좋아요
    func likeQuestion() {
        isLiked.toggle()
        likeCount += isLiked ? 1 : -1

        guard let url = URL(string: "http://localhost/findmemory/like_question.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "question_id=\(questionId)&user_id=\(userId)".data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request).resume()
    }

    // 댓글 등록
    func addCommentToServer() {
        guard let url = URL(string: "http://localhost/findmemory/add_answer.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        let body = "question_id=\(questionId)&author_id=\(userId)&body=\(commentText)"
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        request.httpBody = body?.data(using: .utf8)

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                commentText = ""
                loadDetail()
            }
        }.resume()
    }

    // 댓글 채택
    func acceptComment(_ id: Int) {
        guard let url = URL(string: "http://localhost/findmemory/accept_answer.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "answer_id=\(id)&question_id=\(questionId)".data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                acceptedCommentId = id
                loadDetail()
            }
        }.resume()
    }

    // 댓글 삭제
    func deleteComment(_ id: Int) {
        guard let url = URL(string: "http://localhost/findmemory/delete_answer.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "answer_id=\(id)".data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                loadDetail()
            }
        }.resume()
    }

    // 질문 삭제
    func deleteQuestion() {
        guard let url = URL(string: "http://localhost/findmemory/delete_question.php") else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "question_id=\(questionId)".data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { _, _, _ in
            DispatchQueue.main.async {
                dismiss()
            }
        }.resume()
    }
}

#Preview {
<<<<<<< HEAD
    QuestionDetailView(questionId: 10)
=======
    QuestionDetailView(questionId: 9)
>>>>>>> c53dc73 (✨Feat: 게시글 키워드 카드검색, 등록 및 키워드 카드 참여자수, 게시글 수 기능 추가)
}
