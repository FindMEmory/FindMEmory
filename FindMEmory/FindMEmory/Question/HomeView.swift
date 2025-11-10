//
//  HomeView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack{
            ScrollView{
                HeaderGroup
                    .padding(.horizontal)
                GoWriteGroup
                    .padding(.horizontal)
                QuestionRowListGroup(sortItem: SortItem(
                    sortItem: "인기 질문"
                ))
                QuestionRowListGroup(sortItem: SortItem(
                    sortItem: "최근 질문"
                ))
                QuestionRowListGroup(sortItem: SortItem(
                    sortItem: "답변을 기다리고 있어요"
                ))
            }}
    }
    
    private var HeaderGroup: some View {
        HStack{
            Text("FindMemory")
                .font(.largeTitle)
                .bold()
            Spacer()
            NavigationLink(destination: NotificationView()){
                Image(systemName: "bell")
                    .resizable()
                    .frame(width: 27, height: 27)
                    .foregroundStyle(.black)
            }
        }
        .padding()
    }
    
    private var GoWriteGroup: some View {
        VStack(alignment: .leading){
            Text("홍길동님,")
                .font(.headline)
                .bold()
            Text("오늘은 어떤 기억을 떠올렸나요?")
                .font(.headline)
                .bold()
            NavigationLink("글 작성하러가기", destination: QuestionEditView())
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.gray)
                )
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
