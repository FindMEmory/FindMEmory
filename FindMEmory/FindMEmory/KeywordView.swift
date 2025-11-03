//
//  KeywordView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct KeywordView: View {
    var body: some View {
        NavigationStack{
            Text("KeywordView")
            NavigationLink("+ 키워드 카드 만들기", destination: CreateKeywordView())
            
            NavigationLink("키워드 카드", destination: KeywordDetailView())
        }
    }
}

#Preview {
    KeywordView()
}
