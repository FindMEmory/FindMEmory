//
//  SignupView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct SignupView: View {
    
    @State private var successSignup: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Button(action: {
                    successSignup.toggle()
                }, label: {
                        Text("signup")
                })
            }
            .navigationDestination(isPresented: $successSignup) {
                LoginView()
            }
        }
    }
}

#Preview {
    SignupView()
}
