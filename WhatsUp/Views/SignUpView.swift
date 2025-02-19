//
//  SignUpView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/10/25.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var displayName: String = ""
    
    @EnvironmentObject private var firebaseModel: FirebaseModel
    @EnvironmentObject private var appState: AppState
    
    private var isFormValid: Bool {
        !email.isEmptyOrWhiteSpace
        && !password.isEmptyOrWhiteSpace
        && !displayName.isEmptyOrWhiteSpace
    }
    
    /*
    private func updateDisplayName(user: User) async{
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try? await request.commitChanges()
    }
     */
    
    private func signUp() async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            try await firebaseModel.updateDisplayName(for: result.user, displayName: displayName)
            // go to the Login screen
            appState.routes.append(.login)
        } catch(let error) {
            print(error)
            appState.errorWrapper = ErrorWrapper(error: error)
        }
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
                .textInputAutocapitalization(.never)
            
            TextField("Display Name", text: $displayName)
            
            HStack{
                Spacer()
                Button("SignUp"){
                    Task {
                        await signUp()
                    }
                }.disabled(!isFormValid)
                    .buttonStyle(.borderless)
                
                Button("Login") {
                    // take the user to login screen
                    appState.routes.append(.login)
                }.buttonStyle(.borderless)
                Spacer()
            }
        }
    }
}

#Preview {
    SignUpView()
        .environmentObject(FirebaseModel())
        .environmentObject(AppState())
    
}
