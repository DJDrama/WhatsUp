//
//  ChatMessageListView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/15/25.
//

import SwiftUI
import FirebaseAuth

struct ChatMessageListView: View {
    let chatMessages: [ChatMessage]
    
    private func isChatMessageFromCurrentUser(_ chatMessage: ChatMessage) -> Bool {
        guard let currentUser = Auth.auth().currentUser else {
            return false
        }
        return currentUser.uid == chatMessage.uid
    }
    
    var body: some View {
        ScrollView{
            VStack{
                ForEach(chatMessages) { chatMessage in
                    VStack{
                        if isChatMessageFromCurrentUser(chatMessage) {
                            HStack{
                                Spacer()
                                ChatMessageView(chatMessage: chatMessage, direction: .right, color: .blue)
                            }
                        }else {
                            HStack{
                                ChatMessageView(chatMessage: chatMessage, direction: .left, color: .gray)
                                Spacer()
                            }
                        }
                        Spacer().frame(height: 20)
                            .id(chatMessage.id) // set id
                    }.listRowSeparator(.hidden)
                }
            }
        }
        .padding([.bottom], 60)
    }
}

#Preview {
    ChatMessageListView(chatMessages: [
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
    ])
}
