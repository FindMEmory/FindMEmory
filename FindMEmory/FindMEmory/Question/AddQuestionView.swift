//
//  AddQuestionView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI
import PhotosUI
import UniformTypeIdentifiers

struct AddQuestionView: View {

    @Environment(\.dismiss) private var dismiss


    @State private var title = ""
    @State private var content = ""

    @AppStorage("user_id") private var userId: Int = 0

    @State private var selectedKeyword: KeywordModel?
    @State private var showSelectKeyword = false

    @State private var selectedImages: [UIImage] = []
    @State private var selectedItems: [PhotosPickerItem] = []

    @State private var showPhotoPicker = false
    @State private var showFileImporter = false

    @State private var showAlert = false
    @State private var msg = ""

    // MARK: - Body
    var body: some View {
        VStack(spacing: 20) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    fileAttachSection
                    titleSection
                    contentSection
                    keywordSection
                    submitButton
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .navigationTitle("질문하기")
        .navigationBarTitleDisplayMode(.inline)
        .photosPicker(
            isPresented: $showPhotoPicker,
            selection: $selectedItems,
            maxSelectionCount: 10,
            matching: .images
        )
        .onChange(of: selectedItems, perform: loadImages)
        .fileImporter(
            isPresented: $showFileImporter,
            allowedContentTypes: [.item]
        ) { _ in }
        .sheet(isPresented: $showSelectKeyword) {
            KeywordPickerSheet(
                selectedKeyword: $selectedKeyword
            ) { keyword in
                selectedKeyword = keyword
                showSelectKeyword = false
            }
        }
        .alert("알림", isPresented: $showAlert) {
            Button("확인", role: .cancel) {}
        } message: {
            Text(msg)
        }
    }

    // MARK: - Sections

    private var fileAttachSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    Menu {
                        Button {
                            showPhotoPicker = true
                        } label: {
                            Label("사진 보관함", systemImage: "photo")
                        }

                        Button {
                            showFileImporter = true
                        } label: {
                            Label("파일 찾아보기", systemImage: "folder")
                        }
                    } label: {
                        VStack(spacing: 6) {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 40))
                                .foregroundStyle(.black)
                            Text("(\(selectedImages.count)/10)")
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                        }
                        .frame(width: 80, height: 100)
                    }

                    ForEach(selectedImages, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("파일 첨부")
                    .font(.system(size: 13, weight: .medium))
                Text("이미지, 녹음 파일 등 나의 기억을 복기하는 데 도움이 된다면 뭐든 좋아요")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
        }
        .padding(.top, 10)
    }

    private var titleSection: some View {
        TextField("제목", text: $title)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 1)
            )
            .font(.system(size: 15))
    }

    private var contentSection: some View {
        TextEditor(text: $content)
            .frame(height: 200)
            .padding(8)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.black, lineWidth: 1)
            )
            .overlay(alignment: .topLeading) {
                if content.isEmpty {
                    Text("기억을 자세히 설명해주세요.")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 10)
                }
            }
    }

    private var keywordSection: some View {
        Button {
            showSelectKeyword = true
        } label: {
            HStack(spacing: 6) {
                Image(.keyword)
                Text(selectedKeyword?.name ?? "키워드 카드 등록하기")
            }
            .foregroundColor(.black)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
            .overlay(
                RoundedRectangle(cornerRadius: 22)
                    .stroke(.black, lineWidth: 1)
            )
        }
    }

    private var submitButton: some View {
        Button {
            registerQuestion()
        } label: {
            Text("등록하기")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(.black)
                .cornerRadius(20)
        }
        .padding(.top, 10)
    }

    // MARK: - Helpers

    private func loadImages(_ items: [PhotosPickerItem]) {
        Task {
            for item in items {
                if let data = try? await item.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImages.append(image)
                }
            }
        }
    }

    // MARK: - API

    func registerQuestion() {

        guard !title.isEmpty, !content.isEmpty else {
            msg = "제목과 내용을 모두 입력해주세요."
            showAlert = true
            return
        }

        guard userId != 0 else {
            msg = "로그인 정보가 없습니다."
            showAlert = true
            return
        }

        guard let url = URL(string: "http://localhost/findmemory/add_question.php") else {
            msg = "URL 오류"
            showAlert = true
            return
        }

        var params: [String: String] = [
            "title": title,
            "body": content,
            "author_id": "\(userId)"
        ]

        if let keywordId = selectedKeyword?.id {
            params["keyword_id"] = "\(keywordId)"
        }

        let encoded = params
            .map { key, value in
                "\(key)=\(value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
            }
            .joined(separator: "&")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = encoded.data(using: .utf8)
        request.setValue(
            "application/x-www-form-urlencoded; charset=utf-8",
            forHTTPHeaderField: "Content-Type"
        )

        URLSession.shared.dataTask(with: request) { data, _, error in

            if let error = error {
                DispatchQueue.main.async {
                    msg = "네트워크 오류: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }

            guard
                let data = data,
                let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                let message = json["message"] as? String
            else {
                DispatchQueue.main.async {
                    msg = "응답 처리 오류"
                    showAlert = true
                }
                return
            }

            DispatchQueue.main.async {
                msg = message
                showAlert = true

                if let status = json["status"] as? String, status == "success" {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        dismiss()
                    }
                }
            }

        }.resume()
    }
}

#Preview {
    NavigationStack {
        AddQuestionView()
    }
}
