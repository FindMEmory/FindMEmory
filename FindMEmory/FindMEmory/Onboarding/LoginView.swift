//
//  LoginView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct LoginView: View {
    @State private var loginId = ""
    @State private var loginPwd = ""
    @State private var goMain = false
    @State private var showAlert = false
    @State private var msg = ""
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                // 로고
                Spacer()
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 120, height: 120)
                    .cornerRadius(8)
                Spacer()
                
                // 아이디 입력
                TextField("아이디", text: $loginId)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    )
                    .textInputAutocapitalization(.never)
                
                // 비밀번호 입력
                SecureField("비밀번호", text: $loginPwd)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.6), lineWidth: 1)
                    )
                
                // 로그인 버튼
                Button {
                    loginAction()
                } label: {
                    Text("로그인")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray)
                        .cornerRadius(10)
                }
                .alert(isPresented: $showAlert) {
                    Alert(title: Text("알림"), message: Text(msg), dismissButton: .default(Text("확인")))
                }
                
                // 회원가입 버튼
                NavigationLink(destination: SignupView()) {
                    Text("회원가입")
                        .font(.system(size: 13))
                        .foregroundColor(.gray)
                        .underline(false)
                }
                .padding(.top, 8)
                
                Spacer()
            }
            .padding(.horizontal, 30)
            .navigationBarBackButtonHidden(true)
            .navigationDestination(isPresented: $goMain) {
                BottomTabView()
            }
        }
    }
    
    // MARK: - 로그인 처리
    func loginAction() {
        guard !loginId.isEmpty else { msg = "아이디를 입력하세요."; showAlert = true; return }
        guard !loginPwd.isEmpty else { msg = "비밀번호를 입력하세요."; showAlert = true; return }
        
        guard let url = URL(string: "http://localhost/findmemory/login.php") else {
            msg = "URL 오류"; showAlert = true; return
        }
        
        let body = "login_id=\(loginId)&login_pwd=\(loginPwd)"
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
            print("login response:", str)
            
            DispatchQueue.main.async {
                if str.contains("성공") || str == "1" {
                    goMain = true
                } else {
                    msg = "로그인 실패: \(str)"
                    showAlert = true
                }
            }
        }.resume()
    }
}

#Preview {
    LoginView()
}
