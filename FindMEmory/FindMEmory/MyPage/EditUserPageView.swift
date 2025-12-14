//
//  EditUserPageView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct EditUserPageView: View {
    @Environment(\.dismiss) private var dismiss

    @AppStorage("user_id") private var loginUserId: Int = 0

    @State private var loginId: String = ""
    @State private var nickname: String = ""
    @State private var password: String = ""
    @State private var passwordCheck: String = ""

    @State private var showPassword = false
    @State private var showPasswordCheck = false

    @State private var showAlert = false
    @State private var alertMsg = ""

    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {

                Image(systemName: "person.circle")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .foregroundColor(.gray)
                    .padding(.top, 20)

                // 아이디
                inputField(title: "아이디", text: $loginId)

                // 닉네임
                inputField(title: "닉네임", text: $nickname)

                // 비밀번호
                passwordField(
                    title: "비밀번호",
                    placeholder: "새로운 비밀번호를 입력하세요.",
                    text: $password,
                    isVisible: $showPassword
                )

                // 비밀번호 확인
                passwordField(
                    title: "비밀번호 확인",
                    placeholder: "새로운 비밀번호를 다시 입력하세요.",
                    text: $passwordCheck,
                    isVisible: $showPasswordCheck
                )

                Button(action: updateUser) {
                    Text("수정하기")
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.top, 10)

                Spacer()
            }
            .padding(.horizontal, 24)
            .navigationTitle("계정 정보")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                fetchUserInfo()
            }
            .alert("알림", isPresented: $showAlert) {
                Button("확인") {
                    dismiss() // ✅ 마이페이지로 복귀
                }
            } message: {
                Text(alertMsg)
            }
        }
    }

    // MARK: - 서버 통신

    private func fetchUserInfo() {
        guard let url = URL(
            string: "http://124.56.5.77/IUI/get_user.php?user_id=\(loginUserId)"
        ) else { return }

        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data else { return }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               json["success"] as? Bool == true {
                DispatchQueue.main.async {
                    loginId = json["login_id"] as? String ?? ""
                    nickname = json["nickname"] as? String ?? ""
                }
            }
        }.resume()
    }

    private func updateUser() {
        if password != passwordCheck {
            alertMsg = "비밀번호가 일치하지 않습니다."
            showAlert = true
            return
        }

        guard let url = URL(string: "http://124.56.5.77/IUI/update_user.php") else { return }

        var body = "user_id=\(loginUserId)&login_id=\(loginId)&nickname=\(nickname)"
        if !password.isEmpty {
            body += "&password=\(password)"
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
            .addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)?
            .data(using: .utf8)
        request.setValue("application/x-www-form-urlencoded",
                         forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data else { return }

            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               json["success"] as? Bool == true {
                DispatchQueue.main.async {
                    alertMsg = "수정되었습니다!"
                    showAlert = true
                }
            }
        }.resume()
    }

    // MARK: - UI Components

    private func inputField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            TextField("", text: text)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                )
        }
    }

    private func passwordField(
        title: String,
        placeholder: String,
        text: Binding<String>,
        isVisible: Binding<Bool>
    ) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)

            HStack {
                Group {
                    if isVisible.wrappedValue {
                        TextField(placeholder, text: text)
                    } else {
                        SecureField(placeholder, text: text)
                    }
                }

                Button {
                    isVisible.wrappedValue.toggle()
                } label: {
                    Image(systemName: isVisible.wrappedValue ? "eye.slash" : "eye")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray.opacity(0.6), lineWidth: 1)
            )
        }
    }
}


#Preview {
    EditUserPageView()
}
