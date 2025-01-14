//
//  GroupListContainerView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/14/25.
//

import SwiftUI

struct GroupListContainerView: View {
    @EnvironmentObject private var firebaseModel: FirebaseModel
    @State private var isPresented: Bool = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("New Group") {
                    isPresented = true
                }
            }
            GroupListView(groups: firebaseModel.groups)
            Spacer()
        }.padding()
            .task {
                do{
                    try await firebaseModel.populateGroups()
                }catch{
                    print(error)
                }
            }
            .sheet(isPresented: $isPresented, content: {
                AddNewGroupView()
            })
    }
}

#Preview {
    GroupListContainerView()
        .environmentObject(FirebaseModel())
}
