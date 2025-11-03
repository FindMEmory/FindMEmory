//
//  MyPageView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        NavigationStack{
            Text("MyPageView")
            
            NavigationLink(destination: EditUserPageView()){
                Text("Edit")
            }
            
            NavigationLink(destination: MyAskView()){
                Text("내가 등록한 질문")
            }
            NavigationLink(destination: MyPickView()){
                Text("내가 채택된 질문")
            }
            NavigationLink(destination: MyLikeView()){
                Text("좋아요한 질문")
            }
        }
    }
}

#Preview {
    MyPageView()
}
