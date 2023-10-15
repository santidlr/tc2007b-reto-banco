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
                    let id = data["id"] as? String ?? ""
                    let direction = data["direction"] as? String ?? ""
                    let dateStamp = data["date"] as? Timestamp
                    let numberPeople = data["numberPeople"] as? Int ?? 0
                    let relatedUsers = data["relatedUsers"] as? String ?? ""
                    let isCompleted = data["isCompleted"] as? Bool ?? false
                    let responsibleUsers = data["responsibleUsers"] as? [String] ?? [] // Retrieve responsible users
                    let date = dateStamp?.dateValue() ?? Date() // Convert timestamp to date
                    let delivery = Delivery(id: id, direction: direction, date: date, numberPeople: numberPeople, relatedUsers: relatedUsers, isCompleted: isCompleted, responsibleUsers: responsibleUsers)
                    print("Received delivery: \(delivery)")
                    deliveries.append(delivery)
                }
                completion(deliveries)
            }
        }
    }
    static func getDespensa(completion: @escaping ([Despensa]) -> Void) {
        db.collection("despensa").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting documents from 'despensa': \(error)")
                completion([])
            } else {
                var despensas = [Despensa]()
                despensas.removeAll()
                for document in querySnapshot!.documents {
                    let despensa = Despensa(id: document.documentID, productos: document.data() as? [String: String] ?? [:])
                    despensas.append(despensa)
                }
                completion(despensas)
                print("Fetched Despensa data: \(despensas)")
            }
        }
    }
    static func getInfoTrabajadorS(completion: @escaping ([TrabajadorSocial]) -> Void){
        db.collection("trabajadores").getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error getting document from 'trabajadores': \(error)")
                completion([])
            } else{
                var trabajadores = [TrabajadorSocial]()
                trabajadores.removeAll()
                for document in querySnapshot!.documents{
                    let data = document.data()
                    let name = data["firstName"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let hours = data["horas"] as? String ?? ""
                    
                    let trabajador = TrabajadorSocial(username: name, email: email, serviceHours: hours)
                    trabajadores.append(trabajador)
                    print("Fetched trabajador data: \(trabajador)")
                }
                completion(trabajadores)
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
    var despensa: String
}

struct Delivery: Hashable{
    let id: String
    let direction: String
    let date: Date
    let numberPeople: Int
    let relatedUsers: String
    var isCompleted: Bool
    let responsibleUsers: [String]
}

struct Despensa: Hashable {
    let id: String
    let productos: [String: String]
}

struct TrabajadorSocial: Hashable{
    let username: String
    let email: String
    let serviceHours: String
}
