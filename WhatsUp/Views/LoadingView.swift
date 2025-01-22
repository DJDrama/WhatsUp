//
//  LoadingView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/22/25.
//

import SwiftUI

struct LoadingView: View {
    let message: String
    var body: some View {
        HStack(spacing: 10) {
            ProgressView()
                .tint(.white)
            Text(message)
        }.padding(10)
            .background(.gray)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 16.0, style: .continuous))
    }
}

#Preview {
    LoadingView(message: "Sending...")
}
