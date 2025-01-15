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
            Text(chatMessage.text)
        }
    }
}

#Preview {
    ChatMessageListView(chatMessages: [])
}
