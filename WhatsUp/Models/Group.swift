//
//  Group.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/14/25.
//

import Foundation
import FirebaseFirestore

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
    
    static func fromSnapshot(snapshot: QueryDocumentSnapshot) -> Group? {
        let dictionary = snapshot.data() // dictionary
        guard let subject = dictionary["subject"] as? String else {
            return nil
        }
        return Group(documentId: snapshot.documentID, subject: subject)
    }
}
