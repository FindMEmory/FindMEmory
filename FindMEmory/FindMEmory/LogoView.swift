//
//  LogoView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct LogoView: View {
    @State private var goNext = false
    var body: some View {
        NavigationStack {
                    VStack {
                        Text("로고 또는 스플래시 화면")
                            .font(.title)
                        
                        NavigationLink("", destination: LoginView(), isActive: $goNext)
                            .hidden()
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            goNext = true
                        }
                    }
                }
    }
}

#Preview {
    LogoView()
}
