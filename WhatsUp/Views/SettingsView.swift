//
//  SettingsView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/16/25.
//

import SwiftUI
import FirebaseAuth

struct SettingConfig{
    var showPhotoOptions: Bool = false
    var sourceType: UIImagePickerController.SourceType?
    var selectedImage: UIImage?
    var displayName: String = ""
}

struct SettingsView: View {
    
    @State private var settingConfig = SettingConfig()
    @FocusState private var isEditing: Bool
    
    var displayName: String {
        guard let currentUser = Auth.auth().currentUser else { return "Guest" }
        return currentUser.displayName ?? "Guest"
    }
    
    var body: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill")
                .rounded()
                .onTapGesture {
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
        })
        .padding()
            .onAppear(perform: {
                settingConfig.displayName = displayName
            })
    }
}

#Preview {
    SettingsView()
}
