//
//  NotificationView.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct NotificationView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        HeaderGroup
        NotificationList
        Spacer()
    }
    
    private var HeaderGroup: some View {
        ZStack{
            HStack{
                Button(action: { dismiss() }, label: {
                    Image(systemName: "chevron.backward")
                        .tint(.black)
                })
                Spacer()
            }
            .padding()
            Text("알림")
        }
    }
    
    private var NotificationList: some View {
        VStack{
            NotificationItem(notification: Notification(type: "adopted", title: "이 캐릭터 나온 만화", date: "1분 전"))
        }
    }
}

#Preview {
    NotificationView()
}
