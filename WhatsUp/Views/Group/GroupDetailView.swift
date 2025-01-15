//
//  GroupDetailView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/14/25.
//

import SwiftUI

struct GroupDetailView: View {
    let group: Group
    @EnvironmentObject private var firebaseModel: FirebaseModel
    @State private var chatText=""

    var body: some View {
        VStack {
            Spacer()
            TextField("Enter chat message.", text: $chatText)
            Button("Send"){
                firebaseModel.saveChatMessageToGroup(text: chatText, group: group) { error in
                    if let error {
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
