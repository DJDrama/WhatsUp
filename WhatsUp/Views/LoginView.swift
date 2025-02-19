//
//  LoginView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/10/25.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @EnvironmentObject private var appState: AppState
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var errorMessage: String = ""
    
    private var isFormValid: Bool {
        !email.isEmptyOrWhiteSpace
        && !password.isEmptyOrWhiteSpace
    }
    
    private func login() async{
        do{
            let _ = try await Auth.auth().signIn(withEmail: email, password: password)
            // go to the main screen
            appState.routes.removeAll()
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    var body: some View {
        Form {
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
            SecureField("Password", text: $password)
                .textInputAutocapitalization(.never)
            
            HStack{
                Spacer()
                Button("Login") {
                    Task{
                        await login()
                    }
                }.disabled(!isFormValid).buttonStyle(.borderless)
                Button("SignUp") {
                    // go to the signUp screen
                    appState.routes.append(.signup)
                }.buttonStyle(.borderless)
                Spacer()
            }
            
            if !errorMessage.isEmpty{
                Text(errorMessage)
                    .foregroundStyle(.red)
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(AppState())
}
