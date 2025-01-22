//
//  ErrorView.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/22/25.
//

import SwiftUI

struct ErrorView: View {
    let errorWrapper: ErrorWrapper
    
    var body: some View {
        VStack {
            Text("An error has occurred!")
                .font(.title)
                .padding(.bottom)
            
            Text(errorWrapper.error.localizedDescription)
                .font(.headline)
            
            Text(errorWrapper.guidance)
                .font(.caption)
                .padding(.top)
            
            Spacer()
        }.padding()
            .background(.ultraThinMaterial)
            .cornerRadius(16)
    }
}

#Preview {
    ErrorView(errorWrapper: ErrorWrapper(error: SampleError.operationFailed,
                                        guidance: "Error Happened!"))
}

enum SampleError: Error {
    case operationFailed
}
