//
//  SignupView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct SignupView: View {
    // 입력값
    @State private var loginId = ""
    @State private var nickname = ""
    @State private var loginPwd = ""
    @State private var confirmPwd = ""
    
    // 이동 / 알림
    @State private var successSignup = false
    @State private var showAlert = false
    @State private var msg = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // 아이디
            VStack(alignment: .leading, spacing: 6) {
                Text("아이디")
                    .font(.system(size: 15, weight: .semibold))
                TextField("아이디를 입력하세요.", text: $loginId)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.6), lineWidth: 1))
            }
            
            // 닉네임
            VStack(alignment: .leading, spacing: 6) {
                Text("닉네임")
                    .font(.system(size: 15, weight: .semibold))
                TextField("닉네임을 입력하세요.", text: $nickname)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.6), lineWidth: 1))
            }
            
            // 비밀번호
            VStack(alignment: .leading, spacing: 6) {
                Text("비밀번호")
                    .font(.system(size: 15, weight: .semibold))
                SecureField("비밀번호를 입력하세요.", text: $loginPwd)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.6), lineWidth: 1))
            }
            
            // 비밀번호 확인
            VStack(alignment: .leading, spacing: 6) {
                Text("비밀번호 확인")
                    .font(.system(size: 15, weight: .semibold))
                SecureField("비밀번호를 다시 입력하세요.", text: $confirmPwd)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.6), lineWidth: 1))
            }
            
            Spacer()
            
            // 회원가입 버튼
            Button {
                validateAndSignup()
            } label: {
                Text("회원가입")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .cornerRadius(10)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("알림"), message: Text(msg), dismissButton: .default(Text("확인")))
            }
            
        }
        .padding(.horizontal, 24)
        .padding(.top, 20)
        .navigationTitle("회원가입")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $successSignup) {
            LoginView()
        }
    }
    
    // MARK: - 검증 및 서버 전송
    func validateAndSignup() {
        guard !loginId.isEmpty else { msg = "아이디를 입력하세요."; showAlert = true; return }
        guard !nickname.isEmpty else { msg = "닉네임을 입력하세요."; showAlert = true; return }
        guard !loginPwd.isEmpty else { msg = "비밀번호를 입력하세요."; showAlert = true; return }
        guard loginPwd == confirmPwd else { msg = "비밀번호가 일치하지 않습니다."; showAlert = true; return }
        
        guard let url = URL(string: "http://localhost/findmemory/signup.php") else {
            msg = "URL 오류"; showAlert = true; return
        }
        
        let body = "login_id=\(loginId)&login_pwd=\(loginPwd)&nickname=\(nickname)&grade=1&status=1"
        let bodyData = body.data(using: .utf8)
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.setValue("application/x-www-form-urlencoded; charset=utf-8",
                         forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    msg = "네트워크 오류: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }
            
            let str = String(data: data ?? Data(), encoding: .utf8)?
                .trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            print("signup response:", str)
            
            DispatchQueue.main.async {
                if str.contains("성공") || str == "1" {
                    successSignup = true
                } else {
                    msg = "가입 실패: \(str)"
                    showAlert = true
                }
            }
        }.resume()
    }
}

#Preview {
    NavigationStack { SignupView() }
}
