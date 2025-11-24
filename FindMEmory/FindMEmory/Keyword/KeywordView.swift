//
//  KeywordView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct KeywordView: View {
    @State var keywordQuery:String = ""
    @State private var keywordList: [KeywordModel] = []
    
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
            .onAppear {
                fetchKeywords()
            }
            .padding(.horizontal, 15)
        }
            
    }
    
    func fetchKeywords() {
        guard let url = URL(string: "http://127.0.0.1/findmemory/get_keyword.php") else {
            print("URL Error")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                print("요청 에러:", error)
                return
            }
            
            guard let data = data else {
                print("데이터 없음")
                return
            }
            
            let str = String(decoding: data, as: UTF8.self)
            print("서버 응답:", str)
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(KeywordListResponse.self, from: data)
                
                DispatchQueue.main.async {
                    if response.success {
                        self.keywordList = response.keywords
                    }
                }
            } catch {
                print("디코딩 오류:", error)
            }
            
        }.resume()
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
        VStack(alignment: .leading, spacing: 15) {
            Text("인기 키워드 카드")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(keywordList) { item in
                        NavigationLink(destination: KeywordDetailView(keyword: item)) {
                            Keyword(keywordName: item.name)
                        }
                    }
                }
            }
        }
    }

    
    var newestKeywords: some View {
        VStack(alignment:.leading, spacing: 15){
            Text("최근 키워드 카드")
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(keywordList) { item in
                        NavigationLink(destination: KeywordDetailView(keyword: item)) {
                            Keyword(keywordName: item.name)
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
