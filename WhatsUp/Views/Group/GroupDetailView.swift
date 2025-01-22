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
    @EnvironmentObject private var appState: AppState
    @State private var groupDetailConfig = GroupDetailConfig()
    @FocusState private var isChatTextFieldFocused: Bool
    
    
    private func sendMessage() async throws {
        guard let currentUser = Auth.auth().currentUser else { return }
        var chatMessage = ChatMessage(text: groupDetailConfig.chatText, uid: currentUser.uid, displayName: currentUser.displayName ?? "Guest", profilePhotoURL: currentUser.photoURL == nil ? "" : currentUser.photoURL!.absoluteString)
        
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
    
    private func clearFields() {
        groupDetailConfig.clearForm()
        appState.loadingState = .idle
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
        .overlay(alignment: .center, content: {
            if let selectedImage = groupDetailConfig.selectedImage {
                PreviewImageView(selectedImage: selectedImage) {
                    withAnimation {
                        groupDetailConfig.selectedImage = nil
                    }
                }
            }
        })
        .overlay(alignment: .bottom, content: {
            ChatMessageInputView(groupDetailConfig: $groupDetailConfig, isChatTextFieldFocused: _isChatTextFieldFocused) {
                // send message
                Task {
                    do{
                        appState.loadingState = .loading("Sending...")
                        try await sendMessage()
                        clearFields()
                    } catch{
                        print(error.localizedDescription)
                        appState.loadingState = .idle
                    }
                }
            }.padding()}
        )
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
        .environmentObject(AppState())
}
