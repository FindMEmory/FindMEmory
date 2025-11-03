//
//  QuestionDetailView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct QuestionDetailView: View {
    var body: some View {
        NavigationStack{
            Text("QuestionDetailView")
            
            NavigationLink(destination: QuestionEditView()){
                Text("수정")
            }
            
        }
    }
}

#Preview {
    QuestionDetailView()
}
