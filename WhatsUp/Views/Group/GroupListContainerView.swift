//
//  GroupListContainerView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/14/25.
//

import SwiftUI

struct GroupListContainerView: View {
    @State private var isPresented: Bool = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("New Group") {
                    isPresented = true
                }
            }
            Spacer()
        }.padding()
            .sheet(isPresented: $isPresented, content: {
                AddNewGroupView()
            })
    }
}

#Preview {
    GroupListContainerView()
}
