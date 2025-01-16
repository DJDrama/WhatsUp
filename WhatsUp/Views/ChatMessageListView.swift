//
//  ChatMessageListView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/15/25.
//

import SwiftUI

struct ChatMessageListView: View {
    let chatMessages: [ChatMessage]
    var body: some View {
        List(chatMessages) { chatMessage in
            ChatMessageView(chatMessage: chatMessage, direction: .right, color: .blue)
        }.listStyle(.plain)
    }
}

#Preview {
    ChatMessageListView(chatMessages: [
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
        ChatMessage(text: "Hello World", uid: "1", displayName: "DJ"),
    ])
}
