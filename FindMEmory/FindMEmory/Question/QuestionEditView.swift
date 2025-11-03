//
//  QuestionEditView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct QuestionEditView: View {
    @State private var successEdit: Bool = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack{
            VStack{
                Text("QuestionEditView")
                Button(action: {
                    successEdit.toggle()
                    if successEdit {
                        dismiss()
                    }
                }, label: {
                    Text("수정하기")
                })
            }
        }
    }
}

#Preview {
    QuestionEditView()
}
