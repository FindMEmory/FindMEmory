//
//  CreateKeywordView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct CreateKeywordView: View {
    @State private var successCreate: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack{
                Text("CreateKeywordView")
                Button(action: {
                    successCreate.toggle()
                    dismiss()
                }, label: {
                    Text("등록하기")
                })
            }
        }
    }
}

#Preview {
    CreateKeywordView()
}
