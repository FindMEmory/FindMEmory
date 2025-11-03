//
//  EditUserPageView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct EditUserPageView: View {
    @State private var successEdit: Bool = false
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("EditUserPageView")
                Button(action: {
                    successEdit.toggle()
                }, label: {
                    Text("수정하기")
                })
            }
            .navigationDestination(isPresented: $successEdit) {
                MyPageView()
            }
        }
    }
}

#Preview {
    EditUserPageView()
}
