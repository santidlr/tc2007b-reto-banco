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
    
    var body: some View {
        VStack {
            Text("Detalles entrega")
                .font(.largeTitle)
                .padding(.bottom)

            
            // Display delivery details here (e.g., delivery.direction, delivery.date, etc.)
            
            HStack {
                Text("Nombre")
                    .font(.subheadline)
                    .foregroundColor(.black)
                    .padding(.trailing, 40) // Adjust spacing as needed
                Text("Asistencia")
                    .font(.subheadline)
                    .foregroundColor(.black)
            }
            
            List {
                ForEach(users, id: \.id) { user in
                        HStack(alignment: .center, spacing: 65){
                                HStack(alignment: .center, spacing: 50){
                                    Text(user.firstName)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                    + Text(" ")
                                    + Text(user.lastName)
                                        .font(.subheadline)
                                        .foregroundColor(.black)
                                }
                                VStack{
                                    Text("Asistio?")
                                }
                        }
                }
            }
            .scrollContentBackground(.hidden)
            .frame(width: 250)
            .onAppear {
                fetchUserData()
            }
            .foregroundColor(.orange)
        }
    }
    
    // MARK: - Fetch Functions
    
    private func fetchUserData() {
        users.removeAll()
        bundleRef.getDocument { snapshot, error in
            if let error = error {
                print("Error fetching bundle document: \(error)")
                return
            }
            
            if let data = snapshot?.data(),
               let userIDs = data["users"] as? [String] {
                for userID in userIDs {
                    fetchUserByID(userID)
                }
            }
        }
    }
    
    private func fetchUserByID(_ userID: String) {
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
}








