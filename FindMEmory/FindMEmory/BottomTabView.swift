//
//  BottomTabView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct BottomTabView: View {
    var body: some View {
        TabView {
            Tab("홈", systemImage: "house.fill"){
                HomeView()
            }
            Tab("검색", systemImage: "magnifyingglass"){
                SearchView()
            }
            Tab("키워드", image: "keyword"){
                KeywordView()
            }
            Tab("마이 페이지", systemImage: "person.circle"){
                MyPageView()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    BottomTabView()
}
