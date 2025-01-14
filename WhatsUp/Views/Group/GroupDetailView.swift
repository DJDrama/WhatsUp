//
//  GroupDetailView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/14/25.
//

import SwiftUI

struct GroupDetailView: View {
    let group: Group
    var body: some View {
        Text("\(group.subject)")
    }
}

#Preview {
    GroupDetailView(group: Group(subject: "Hello"))
}
