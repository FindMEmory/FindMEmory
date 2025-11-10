//
//  CreateKeywordView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI
import PhotosUI


struct CreateKeywordView: View {
    @State private var successCreate: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var keywordName: String = ""
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    
    var body: some View {
        NavigationStack{
            VStack{
                selectImage
                Spacer()
                    .frame(height: 30)
                setKeywordName
                info
                Spacer()
                registerButton
            }
            .padding(.horizontal, 15)
        }.navigationTitle("키워드 카드 만들기")
    }
    
    
    var selectImage: some View {
        VStack {
            
            PhotosPicker(selection: $selectedItem, matching: .images) {
                if let image = selectedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 250, height: 250)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.3))
                        )
                } else {
                    VStack(spacing: 10) {
                        Spacer().frame(height:40)
                        Image(systemName: "plus")
                            .foregroundStyle(.black)
                        Group {
                            Text("대표 이미지")
                            Text("키워드 카드를 나타낼 수 있는\n이미지를 추가해주세요")
                        }
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.center)
                    }
                    .frame(width: 250, height: 250)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(.gray.opacity(0.2))
                    )
                }
            }
            .onChange(of: selectedItem) { oldValue, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let uiImage = UIImage(data: data) {
                        selectedImage = uiImage
                    }
                }
            }
            .padding(.top, 130)
            .padding(.bottom, 50)
        }
    }

        
    
    var setKeywordName : some View {
        TextField("키워드를 입력해주세요", text: $keywordName)
            .padding(10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.gray, style: StrokeStyle(lineWidth: 1))
            )
            .padding(.bottom, 20)
    }
    
    var info: some View {
        VStack(alignment: .leading, spacing: 5){
            HStack{
                Image(systemName: "info.circle")
                Text("키워드 카드")
            }
            
            Text("- 해당 키워드에 해당하는 게시글들을 모아볼 수 있습니다.\n- 같은 키워드에 관심을 가지는 사람들끼리 자유롭게    대화를 나눌 수 있습니다.")
        }
        .font(.system(size: 16))
        .foregroundStyle(.gray)

    }
    
    var registerButton:some View{
        Button(action: {
            successCreate.toggle()
            dismiss()
        }, label: {
            Text("등록하기")
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .frame(width:340, height: 45)
                        .foregroundStyle(.black)
                        
                )
        })
    }
}

#Preview {
    CreateKeywordView()
}
