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
    
    func updateDisplayName(for user: User, displayName: String) async throws {
        let request = user.createProfileChangeRequest()
        request.displayName = displayName
        try await request.commitChanges()
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
