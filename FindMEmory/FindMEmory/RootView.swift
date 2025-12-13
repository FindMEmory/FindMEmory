//
//  ContentView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct RootView: View {
    @AppStorage("is_logged_in") var isLoggedIn: Bool = false

    var body: some View {
        Group {
            if isLoggedIn {
                BottomTabView()
            } else {
                LoginView()
            }
        }
        .id(isLoggedIn)
    }
}

#Preview {
    RootView()
}
