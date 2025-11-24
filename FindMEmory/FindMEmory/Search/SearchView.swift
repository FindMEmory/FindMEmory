//
//  SearchView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct SearchView: View {
    var body: some View {
        NavigationStack{
            Text("SearchView")
            NavigationLink(destination: KeywordDetailView()){
                Text("키워드 카드")
            }
            NavigationLink(destination:  QuestionDetailView(questionId: 1)){
                Text("게시글")
            }

        }
    }
}

#Preview {
    SearchView()
}
