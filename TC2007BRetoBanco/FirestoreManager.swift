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

  
    static func getEntregas(completion: @escaping ([Delivery]) -> Void){
        db.collection("deliveries").getDocuments(){(QuerySnapshot, err) in
            if let err = err{
                print("Error getting document \(err)")
                completion([])
            } else{
                var deliveries = [Delivery]()
                deliveries.removeAll()
                for document in QuerySnapshot!.documents{
                    let data = document.data()
                    let direction = data["direction"] as? String ?? ""
                    let date = data["date"] as? String ?? ""
                    let numberPeople = data["numberPeople"] as? Int ?? 0
                    let relatedUsers = data["relatedUsers"] as? String ?? ""
                    let responsibleUsers = data["responsibleUsers"] as? [String] ?? [] // Retrieve responsible users
                    let delivery = Delivery(direction: direction, date: date, numberPeople: numberPeople, relatedUsers: relatedUsers, responsibleUsers: responsibleUsers)
                    print("Received delivery: \(delivery)")
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
    var attendance: Bool
}

struct Delivery: Hashable{
    let direction: String
    let date: String
    let numberPeople: Int
    let relatedUsers: String
    let responsibleUsers: [String]
}
