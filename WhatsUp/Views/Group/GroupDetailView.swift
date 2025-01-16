//
//  GroupDetailView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/14/25.
//

import SwiftUI
import FirebaseAuth

struct GroupDetailView: View {
    let group: Group
    @EnvironmentObject private var firebaseModel: FirebaseModel
    @State private var chatText = ""
    
    private func sendMessage() async throws {
        guard let currentUser = Auth.auth().currentUser else { return }
        let chatMessage = ChatMessage(text: chatText, uid: currentUser.uid, displayName: currentUser.displayName ?? "Guest")
        try await firebaseModel.saveChageMessageToGroup(chatMessage: chatMessage, group: group)
    }

    var body: some View {
        VStack {
            ScrollViewReader { proxy in
                ChatMessageListView(chatMessages: firebaseModel.chatMessages)
                    .onChange(of: firebaseModel.chatMessages) { oldValue, newValue in
                        if !firebaseModel.chatMessages.isEmpty {
                            let lastChatMessage = firebaseModel.chatMessages.last
                            withAnimation {
                                proxy.scrollTo(lastChatMessage!.id, anchor: .bottom)
                            }
                        }
                    }
            }
            Spacer()
            TextField("Enter chat message.", text: $chatText)
            Button("Send"){
                Task{
                    do{
                        try await sendMessage()
                        chatText = ""
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }.padding()
            .onAppear {
                firebaseModel.listenForChatMessages(in: group)
            }
            .onDisappear(perform: {
                firebaseModel.detachFirebaseListener()
            })
    }
}

#Preview {
    GroupDetailView(group: Group(subject: "Hello"))
        .environmentObject(FirebaseModel())
}
