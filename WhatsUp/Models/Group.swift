//
//  Group.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/14/25.
//

import Foundation

// Codable: For Firebase Database
struct Group: Codable, Identifiable {
    var documentId: String? = nil
    let subject: String
    
    var id: String {
        documentId ?? UUID().uuidString
    }
}

extension Group {
    func toDictionary() -> [String: Any] {
        return ["subject": subject]
    }
}
