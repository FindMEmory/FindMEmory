//
//  SearchView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchContent: String = ""
    
    var body: some View {
        NavigationStack{
            HeaderGroup
            TextField("검색", text: $searchContent)
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.gray, lineWidth: 1)
                )
                .padding(.horizontal, 10)
            KeywordCardGroup
QuestionGroup
        }
    }
    
    private var HeaderGroup: some View {
        HStack{
            Text("FindMEmory")
                .bold()
            Spacer()
            NavigationLink(destination: NotificationView()){
                Image(systemName: "bell")
                    .tint(.black)
            }
        }
        .padding()
    }
    
    private var KeywordCardGroup: some View {
        VStack(alignment: .leading){
            Text("인기 키워드 카드")
            ScrollView{
                HStack{
                    
                }
            }
        }
    }
    
    private var QuestionGroup: some View {
        VStack(alignment: .leading, spacing: 10){
            Text("게시글")
            
        }
    }
}

#Preview {
    SearchView()
}
