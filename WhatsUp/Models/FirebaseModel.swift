//
//  Model.swift
//  WhatsUp
//
//  Created by Dongjun Lee on 1/10/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

// Aggregate Model
@MainActor
class FirebaseModel: ObservableObject {
    @Published var groups: [Group] = []
    @Published var chatMessages: [ChatMessage] = []
    
    var firestoreListener: ListenerRegistration?
    
    func detachFirebaseListener() {
        self.firestoreListener?.remove()
    }
    
    func updateDisplayName(for user: User, displayName: String) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
    }
    
    func listenForChatMessages(in group: Group) {
        let db = Firestore.firestore()
        chatMessages.removeAll()
        guard let documentId = group.documentId else { return }
        
        self.firestoreListener = db.collection("groups")
            .document(documentId)
            .collection("messages")
            .order(by: "dateCreated", descending: false)
            .addSnapshotListener({ [weak self] snapshot, error in
                // will be fired when changed
                guard let snapshot = snapshot else {
                    print("Error fetching snapshots: \(error!.localizedDescription)")
                    return
                }
                snapshot.documentChanges.forEach { diff in
                    if diff.type == .added {
                        let chatMessage = ChatMessage.fromSnapshot(snapshot: diff.document)
                        if let chatMessage {
                            let exists = self?.chatMessages.contains(where: { cm in
                                cm.documentId == chatMessage.documentId
                            })
                            if !exists! {
                                self?.chatMessages.append(chatMessage)
                            }
                        }
                    }
                }
            })
    }
    
    
    func populateGroups() async throws {
        let db = Firestore.firestore()
        let snapshot = try await db.collection("groups")
            .getDocuments()
        
        // compactMap : removes nil
        groups = snapshot.documents.compactMap { snapshot in
            // need to get a group based on snapshot
            Group.fromSnapshot(snapshot:snapshot)
        }
    }
    
    func saveChageMessageToGroup(chatMessage: ChatMessage, group: Group) async throws {
        let db = Firestore.firestore()
        guard let groupDocumentId = group.documentId else { return }
        let _ = try await db.collection("groups")
            .document(groupDocumentId)
            .collection("messages")
            .addDocument(data: chatMessage.toDictionary())
    }
    
    /*
     func saveChatMessageToGroup(text: String, group: Group, completion: @escaping(Error?) -> Void){
     let db = Firestore.firestore()
     guard let groupDocumentId = group.documentId else { return }
     db.collection("groups")
     .document(groupDocumentId)
     .collection("messages")
     .addDocument(data: ["chatText": text]) { error in
     if error != nil {
     completion(error)
     }else {
     completion(nil)
     }
     }
     }
     */
    
    func saveGroup(group: Group, completion: @escaping(Error?) -> Void) {
        let db = Firestore.firestore()
        var docRef: DocumentReference? = nil
        docRef = db.collection("groups")
            .addDocument(data: group.toDictionary()) { error in
                if error != nil {
                    completion(error)
                } else {
                    // add the group to groups array
                    if let docRef{
                        var newGroup = group
                        newGroup.documentId = docRef.documentID
                        self.groups.append(newGroup)
                        completion(nil)
                    } else {
                        completion(nil)
                    }
                }
            }
    }
}


