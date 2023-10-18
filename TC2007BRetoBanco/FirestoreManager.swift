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
    static func getWorkerByID(workerID: String, completion: @escaping (Worker?) -> Void) {
        let workersCollection = db.collection("trabajadores")

        // Use the workerID directly as the document name
        workersCollection.document(workerID).getDocument { (document, error) in
            if let error = error {
                print("Error getting worker from 'trabajadores': \(error)")
                completion(nil)
            } else if let document = document, document.exists {
                if let data = document.data(),
                   let email = data["email"] as? String,
                   let firstName = data["firstName"] as? String,
                   let lastName = data["lastName"] as? String,
                   let horas = data["horas"] as? Int {
                    let worker = Worker(id: workerID, email: email, firstname: firstName, lastName: lastName, horas: horas)
                    completion(worker)
                } else {
                    print("Error parsing worker data")
                    completion(nil)
                }
            } else {
                print("Worker not found in trabajadores collection")
                completion(nil)
            }
        }
    }
    static func getReporte(completion: @escaping ([Reporte]) -> Void) {
        db.collection("reportesdeentrega").getDocuments { (QuerySnapshot, error) in
            if let error = error{
                print("Error getting reports from 'reportesdeentrega': \(error)")
            } else{
                var reportes = [Reporte]()
                reportes.removeAll()
                for document in QuerySnapshot!.documents{
                    let data = document.data()
                    let dateStamp = data["date"] as? Timestamp
                    let direction = data["direction"] as? String ?? ""
                    let responsibleUsers = data["responsibleUsers"] as? [String] ?? [] // Retrieve responsible users
                    let date = dateStamp?.dateValue() ?? Date()
                    
                    if let usersData = data["users"] as? [[String: Any]] {
                        var userReportsxd: [UserReport] = []
                        for userData in usersData {
                            if let id = userData["id"] as? String,
                               let firstName = userData["firstName"] as? String,
                               let lastName = userData["lastName"] as? String,
                               let attendance = userData["attendance"] as? Bool,
                               let despensa = userData["despensa"] as? String {
                                
                                let userReport = UserReport(id: id, firstName: firstName, lastName: lastName, attendance: attendance, despensa: despensa)
                                userReportsxd.append(userReport)
                            }
                        }
                        let report = Reporte(id: document.documentID, date: date, direction: direction, userReports: userReportsxd, responsibleUsers: responsibleUsers)
                        reportes.append(report)
                        print("Fetched report: \(reportes)")
                    }
                }
                completion(reportes)
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
                    let id = data["userID"] as? String ?? ""
                    let name = data["firstName"] as? String ?? ""
                    let lastName = data["lastName"] as? String ?? ""
                    let email = data["email"] as? String ?? ""
                    let hours = data["horas"] as? String ?? ""
                    
                    let trabajador = TrabajadorSocial(id: id, username: name, lastName: lastName, email: email, serviceHours: hours)
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

struct TrabajadorSocial: Identifiable{
    let id: String
    let username: String
    let lastName: String
    let email: String
    let serviceHours: String
}

struct Reporte: Identifiable {
    let id: String
    let date: Date
    let direction: String
    let userReports: [UserReport]
    let responsibleUsers: [String]
}

struct Worker: Hashable {
    let id: String
    let email: String
    let firstname: String
    let lastName: String
    let horas: Int
}

