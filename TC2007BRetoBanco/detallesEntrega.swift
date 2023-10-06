//
//  detallesEntrega.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 10/5/23.
//

import SwiftUI
import Firebase



struct detallesEntrega: View {
    let delivery: Delivery
    let db = Firestore.firestore()
    let bundleRef: DocumentReference
    
    
    @State private var users: [User] = []
    
    init(delivery: Delivery){
        self.delivery = delivery
        self.bundleRef = db.collection("userbundle").document(delivery.relatedUsers)
        

    }
    
    private func fetchUserData() {
        bundleRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching bundle document: \(error)")
                return
            }
            
            if let data = snapshot?.data(),
               let userIDs = data["users"] as? [String] { // Assuming your array field is named "userIDs"
                
                // Iterate through the user IDs and fetch user data
                for userID in userIDs {
                    // Assuming you have a function to fetch user data by ID
                    fetchUserByID(userID)
                }
            }
        }
    }
    
    private func fetchUserByID(_ userID: String) {
        // Use your function to fetch user data by ID here and append it to the users array
        // Example: Fetch user data from Firestore and append to users array
        db.collection("users").document(userID).getDocument { snapshot, error in
            if let error = error {
                print("Error fetching user document: \(error)")
                return
            }
            if let data = snapshot?.data(),
               let id = data["id"] as? String,
               let firstname = data["first"] as? String,
               let lastname = data["last"] as? String,
               let born = data["born"] as? Int {
                
                let user = User(id: id, firstName: firstname, lastName: lastname, born: born)
                self.users.append(user)
                
                print("User appended: \(user)")
            }
        }
    }
    
    var body: some View {
        VStack {
            Text("Delivery Details")
                .font(.largeTitle)
                .padding()
            
            // Display delivery details here (e.g., delivery.direction, delivery.date, etc.)
            
            Text("Users in Delivery:")
                .font(.headline)
                .padding(.top)
            
            List {
                ForEach(users, id: \.id) { user in
                    HStack {
                        Text("Nombre: \(user.firstName)")
                            .font(.subheadline)
                        Text("Apellido: \(user.lastName)")
                            .font(.subheadline)
                        Text("Nacimiento: \(user.born)")
                            .font(.subheadline)
                    }
                }
            }
            .onAppear{
                fetchUserData()
            }
        }
    }
}






