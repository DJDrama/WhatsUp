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
            Spacer()
            TextField("Enter chat message.", text: $chatText)
            Button("Send"){
                Task{
                    do{
                        try await sendMessage()
                    }catch{
                        print(error.localizedDescription)
                    }
                }
            }
        }.padding()
    }
}

#Preview {
    GroupDetailView(group: Group(subject: "Hello"))
        .environmentObject(FirebaseModel())
}
