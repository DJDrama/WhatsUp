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
    @State private var errorMessage: String = ""
    
    private var isFormValid: Bool {
        !email.isEmptyOrWhiteSpace
        && !password.isEmptyOrWhiteSpace
        && !displayName.isEmptyOrWhiteSpace
    }
    
    private func signUp() async {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
        } catch(let error) {
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
    SignUpView()
}
