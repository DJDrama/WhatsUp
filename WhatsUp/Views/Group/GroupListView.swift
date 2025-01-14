//
//  GroupListView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/14/25.
//

import SwiftUI

struct GroupListView: View {
    let groups: [Group]
    var body: some View {
        List(groups) { group in
            NavigationLink {
                GroupDetailView(group: group)
            } label: {
                HStack {
                    Image(systemName: "person.2")
                    Text(group.subject)
                }
            }
        }.listStyle(.plain)
            
    }
}

#Preview {
    GroupListView(groups: [])
}
