//
//  AddNewGroupView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/14/25.
//

import SwiftUI

struct AddNewGroupView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var groupSubject: String = ""
    
    private var isFormValid: Bool {
        !groupSubject.isEmptyOrWhiteSpace
    }
    var body: some View {
        NavigationStack{
            VStack{
                HStack {
                    TextField("Group Subject", text: $groupSubject)
                }
                Spacer()
            }.toolbar {
                ToolbarItem(placement: .principal) {
                    Text("New Group")
                        .bold()
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Create") {
                        
                    }.disabled(!isFormValid)
                }
            }
        }.padding()
        
    }
}

#Preview {
    NavigationStack{
        AddNewGroupView()
    }
}
