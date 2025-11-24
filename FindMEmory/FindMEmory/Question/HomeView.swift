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
            
            Text("HomeView")
            NavigationLink(destination: NotificationView()){
                Image(systemName: "bell")
            }
            
            NavigationLink("글 작성하러가기", destination: AddQuestionView())
            
            NavigationLink("질문 더보기", destination: QuestionListView())
        }
    }
}

#Preview {
    HomeView()
}
