//
//  LoginView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct LoginView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("로그인", destination: BottomTabView())
            NavigationLink("회원가입", destination: SignupView())
        }
    }
    
}

#Preview {
    LoginView()
}
