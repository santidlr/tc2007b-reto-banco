//
//  FirestoreManager.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 10/4/23.
//

import SwiftUI
import Firebase

struct FirestoreManager {
    static let db = Firestore.firestore()

    static func addUserToFirestore() {
        // Add a new document with a generated ID
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "first": "John",
            "last": "Pork",
            "born": 2001
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    static func getUserFromFirestore(documentID: String, completion: @escaping (User?, Error?) -> Void) {
        let userRef = db.collection("users").document(documentID)

        userRef.getDocument { (document, error) in
            if let error = error {
                completion(nil, error)
            } else {
                if let document = document, document.exists {
                    let data = document.data()
                    let id = data?["id"] as? String ?? ""
                    let firstName = data?["first"] as? String ?? ""
                    let lastName = data?["last"] as? String ?? ""
                    let born = data?["born"] as? Int ?? 0

                    let user = User(id: id, firstName: firstName, lastName: lastName, born: born)
                    completion(user, nil)
                } else {
                    completion(nil, nil) // Document does not exist
                    }
                }
            }
    }
    
    static func getEntregas(completion: @escaping ([Delivery]) -> Void){
        db.collection("deliveries").getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print("Error getting document \(err)")
                completion([])
            } else{
                var deliveries = [Delivery]()
                for document in QuerySnapshot!.documents{
                    let data = document.data()
                    let direction = data["direction"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let numberPeople = data["numberPeople"] as? Int ?? 0
                    let relatedUsers = data["relatedUsers"] as? String ?? ""
        
                    let delivery = Delivery(direction: direction, date: date, numberPeople: numberPeople, relatedUsers: relatedUsers)
                    deliveries.append(delivery)
                }
                completion(deliveries)
            }
        }
    }
}

struct User: Hashable{
    let id: String
    let firstName: String
    let lastName: String
    let born: Int
}

struct Delivery: Hashable{
    let direction: String
    let date: String
    let numberPeople: Int
    let relatedUsers: String
}
