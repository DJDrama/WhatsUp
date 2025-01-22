//
//  SettingsView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/16/25.
//

import SwiftUI
import FirebaseAuth
import FirebaseStorage

struct SettingConfig{
    var showPhotoOptions: Bool = false
    var sourceType: UIImagePickerController.SourceType?
    var selectedImage: UIImage?
    var displayName: String = ""
}

struct SettingsView: View {
    
    @State private var settingConfig = SettingConfig()
    @FocusState private var isEditing: Bool
    @EnvironmentObject private var firebaseModel: FirebaseModel
    @EnvironmentObject private var appState: AppState
    
    @State private var currentPhotoURL: URL? = Auth.auth().currentUser?.photoURL
    
    var displayName: String {
        guard let currentUser = Auth.auth().currentUser else { return "Guest" }
        return currentUser.displayName ?? "Guest"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                AsyncImage(url: currentPhotoURL){ image in
                    image.rounded()
                } placeholder: {
                    Image(systemName: "person.crop.circle.fill")
                        .rounded()
                }.onTapGesture {
                    settingConfig.showPhotoOptions = true
                }.confirmationDialog("Select", isPresented: $settingConfig.showPhotoOptions) {
                    Button("Camera"){
                        settingConfig.sourceType = .camera
                    }
                    Button("Photo Library"){
                        settingConfig.sourceType = .photoLibrary
                    }
                }
                
                TextField(settingConfig.displayName, text: $settingConfig.displayName)
                    .textFieldStyle(.roundedBorder)
                    .focused($isEditing)
                    .textInputAutocapitalization(.never)
                
                Spacer()
                Button("Sign out") {
                    do{
                        try Auth.auth().signOut()
                        appState.routes.append(.login)
                    }catch {
                        // can use errorwrapper
                        print(error.localizedDescription)
                        
                    }
                }
            }
            .sheet(item: $settingConfig.sourceType, content: {sourceType in
                
                ImagePicker(image: $settingConfig.selectedImage, sourceType: sourceType)
            })
            .onChange(of: settingConfig.selectedImage, { oldValue, newValue in
                // resize the image
                guard let image = newValue,
                      let resizedImage = image.resize(to: CGSize(width: 100, height: 100)),
                      let imageData = resizedImage.pngData()
                else { return }
                
                // upload the image to Firebase Storage to get the url
                Task{
                    guard let currentUser = Auth.auth().currentUser else { return }
                    let fileName = "\(currentUser.uid).png"
                    do{
                        let url = try await Storage.storage().uploadData(for: fileName, data: imageData, bucket: .photos)
                        try await firebaseModel.updatePhotoURL(for: currentUser, photoURL: url)
                        currentPhotoURL = url
                    }catch {
                        print(error.localizedDescription)
                    }
                }
                
            })
            .padding()
            .onAppear(perform: {
                settingConfig.displayName = displayName
            })
            .toolbar(content: {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        guard let currentUser = Auth.auth().currentUser else { return }
                        Task{
                            do{
                                try await firebaseModel.updateDisplayName(for: currentUser, displayName: settingConfig.displayName)
                            } catch {
                                print(error.localizedDescription)
                            }
                        }
                    }
                }
            })
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(FirebaseModel())
        .environmentObject(AppState())
}
