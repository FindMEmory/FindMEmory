//
//  Notification.swift
//  FindMEmory
//
//  Created by 권예원 on 10/27/25.
//

import SwiftUI

struct Notification {
    let id = UUID()
    let type: String
    let title: String
    let date: String
}

struct NotificationItem: View {
    let notification: Notification
    
    private var iconName: String {
        switch notification.type {
        case "chat":
            return "ellipsis.message.fill"
        case "heart":
            return "heart.fill"
        case "adopted":
            return "checkmark.circle.fill"
        default:
            return "bell.fill"
        }
    }
    
    private var message: String {
        switch notification.type {
        case "chat":
            return "글에 새로운 답변이 달렸어요"
        case "heart":
            return "글에 새로운 공감이 달렸어요."
        case "adopted":
            return "내 답변이 채택되었어요."
        default:
            return "새로운 알림이 있어요"
        }
    }
    
    var body: some View {
        HStack{
            Image(systemName: iconName)
                .resizable()
                .frame(width: 34, height: 34)
                .padding(.trailing, 10)
            VStack(alignment: .leading){
                Text(notification.title)
                Text(message)
            }
            Spacer()
            Text("\(notification.date)")
        }
        .padding()
    }
}

#Preview {
    NotificationItem(notification: Notification(type: "adopted", title: "이 캐릭터 나온 만화", date: "1분 전"))
}
