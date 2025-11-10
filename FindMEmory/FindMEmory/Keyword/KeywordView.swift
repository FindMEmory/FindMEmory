//
//  KeywordView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct KeywordView: View {
    @State var keywordQuery:String = ""
    
    var body: some View {
        NavigationStack{
            VStack{
                searchBar
                    .padding(.bottom, 10)
                createKeywordButton
                    .padding(.bottom, 10)
                popularKeywords
                    .padding(.bottom, 40)
                newestKeywords
                Spacer()
            }
            .padding(.horizontal, 15)
        }
            
    }
    
    var searchBar: some View {
        TextField("검색", text: $keywordQuery)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, style: StrokeStyle(lineWidth: 1))
            )
    }
    
    var createKeywordButton: some View {
        HStack{
            Spacer()
            NavigationLink(destination: CreateKeywordView()) {
                Text("+ 키워드 카드 만들기")
                    .foregroundColor(.black)
            }
        }
    }
    
    var popularKeywords: some View {
        VStack(alignment:.leading, spacing: 15){
            Text("인기 키워드 카드")
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 15) {
                    ForEach(0..<5, id: \.self) { _ in
                        NavigationLink(destination: KeywordDetailView()){
                            Keyword()
                        }
                    }
                }
            }
        }
    }
    
    var newestKeywords: some View {
        VStack(alignment:.leading, spacing: 15){
            Text("최근 키워드 카드")
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 15) {
                    ForEach(0..<5, id: \.self) { _ in
                        NavigationLink(destination: KeywordDetailView()){
                            Keyword()
                        }
                    }
                }
            }
        }

    }
}

#Preview {
    KeywordView()
}
