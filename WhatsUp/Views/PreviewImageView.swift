//
//  PreviewImageView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/20/25.
//

import SwiftUI

struct PreviewImageView: View {
    let selectedImage: UIImage
    var onCancel: ()->Void
    var body: some View {
        ZStack {
            Image(uiImage: selectedImage)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .overlay(alignment: .top) {
                    Button {
                        onCancel()
                    } label: {
                        Image(systemName: "multiply.circle.fill")
                            .padding([.top], 10)
                            .font(.largeTitle)
                            .foregroundStyle(.white)
                    }
                }
        }
    }
}

