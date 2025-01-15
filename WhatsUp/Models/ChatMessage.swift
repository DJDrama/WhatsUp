//
//  ChatMessage.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/15/25.
//

import Foundation

struct ChatMessage: Codable, Identifiable, Equatable {
    
    var documentId: String?
    let text: String
    let uid: String
    var dateCreated: Date = Date()
    let displayName: String
    
    var id: String{
        documentId ?? UUID().uuidString
    }
    
}


extension ChatMessage {
    func toDictionary() -> [String: Any] {
        return [
            "text": text,
            "uid": uid,
            "dateCreated": dateCreated,
            "displayName": displayName,
        ]
    }
}
