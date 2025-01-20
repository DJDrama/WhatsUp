//
//  GroupDetailView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/14/25.
//

import SwiftUI
import FirebaseStorage
import FirebaseAuth

struct GroupDetailView: View {
    let group: Group
    @EnvironmentObject private var firebaseModel: FirebaseModel
    @State private var chatText = ""
    @State private var groupDetailConfig = GroupDetailConfig()
    @FocusState private var isChatTextFieldFocused: Bool
    
    
    private func sendMessage() async throws {
        guard let currentUser = Auth.auth().currentUser else { return }
        var chatMessage = ChatMessage(text: chatText, uid: currentUser.uid, displayName: currentUser.displayName ?? "Guest", profilePhotoURL: currentUser.photoURL == nil ? "" : currentUser.photoURL!.absoluteString)
        
        if let selectedImage = groupDetailConfig.selectedImage {
                // resize the image
            guard let resizedImage = selectedImage.resize(to: CGSize(width: 600, height: 600)),
                  let imageData = resizedImage.pngData()
            else { return }
            let url = try await Storage.storage().uploadData(for: UUID().uuidString, data: imageData, bucket: .attachments)
            chatMessage.attachmentPhotoURL = url.absoluteString
        }
        
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
        }
        .frame(maxWidth: .infinity)
        .padding()
        .confirmationDialog("Options", isPresented: $groupDetailConfig.showOptions, actions: {
            Button("Camera") {
                groupDetailConfig.sourceType = .camera
            }
            Button("Photo Library"){
                groupDetailConfig.sourceType = .photoLibrary
            }
        })
        .sheet(item: $groupDetailConfig.sourceType, content: { sourceType in
            ImagePicker(image: $groupDetailConfig.selectedImage, sourceType: sourceType)
        })
            .overlay(alignment: .bottom, content: {
                ChatMessageInputView(groupDetailConfig: $groupDetailConfig, isChatTextFieldFocused: _isChatTextFieldFocused) {
                    // send message
                    Task {
                        do{
                            try await sendMessage()
                        } catch{
                            print(error.localizedDescription)
                        }
                    }
                }.padding()
            })
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
