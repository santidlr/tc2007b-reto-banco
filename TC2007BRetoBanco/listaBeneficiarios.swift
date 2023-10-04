//
//  listaBeneficiarios.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 9/30/23.
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
                    let firstName = data?["first"] as? String ?? ""
                    let lastName = data?["last"] as? String ?? ""
                    let born = data?["born"] as? Int ?? 0

                    let user = User(firstName: firstName, lastName: lastName, born: born)
                    completion(user, nil)
                } else {
                    completion(nil, nil) // Document does not exist
                    }
                }
            }
        }
    }

struct User {
    let firstName: String
    let lastName: String
    let born: Int
}

struct listaBeneficiarios: View {
    @State private var user: User?
    @State private var isLoading = false
    @State private var errorMessage = "..."

    var body: some View {
        VStack {
            Button("Add User John"){
                FirestoreManager.addUserToFirestore()
            }
            if isLoading {
                ProgressView("Loading...")
            } else if let user = user {
                Text("First Name: \(user.firstName)")
                Text("Last Name: \(user.lastName)")
                Text("Born: \(user.born)")
            } else {
                Text(errorMessage)
            }

            Button("Fetch User Data") {
                isLoading = true
                FirestoreManager.getUserFromFirestore(documentID: "MABQOSYXpNgr6b3dbiSu") { fetchedUser, error in
                    isLoading = false
                    if let user = fetchedUser {
                        self.user = user
                    } else if let error = error {
                        errorMessage = "Error: \(error.localizedDescription)"
                    } else {
                        errorMessage = "User not found"
                    }
                }
            }
        }
    }
}

struct listaBeneficiarios_Previews: PreviewProvider {
    static var previews: some View {
        listaBeneficiarios()
    }
}
