//
//  Model.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/10/25.
//

import Foundation
import FirebaseAuth

@MainActor
class FirebaseModel: ObservableObject {
    
    func updateDisplayName(for user: User, displayName: String) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
    }
}
