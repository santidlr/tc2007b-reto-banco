//
//  aceptarEntrega.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 10/16/23.
//

import SwiftUI
import Firebase
struct aceptarEntrega: View {
    let db = Firestore.firestore()
    @State private var deliveries: [Delivery] = []
    @State private var pendingUserNames: [String] = []
    var awaitingConfirmationDeliveries: [Delivery] {
        deliveries.filter { !$0.isConfirmed }
    }
    // Perform deduplication or filtering    
    var body: some View {
        NavigationStack {
            List {
                ForEach(awaitingConfirmationDeliveries, id: \.id) { delivery in
                    LazyVGrid(columns: [
                        GridItem(.fixed(80)), // Why no lay properly??
                        GridItem(.fixed(80)),
                        GridItem(.fixed(80)),
                        GridItem(.fixed(70))
                    ], alignment: .leading, spacing: 5) {
                        Text("Solicitud a:")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text("\(delivery.direction)")
                            .font(.subheadline)
                        Text("Fecha limite para aceptar:")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text(formatDate(delivery.date))
                            .font(.subheadline)
                    }
                    
                    // Nested loop to display users and buttons
                    ForEach(delivery.pendingUsers, id: \.self) { user in
                        HStack {
                            Text(user) // Display the user's name or information
                                .font(.subheadline)
                            Button("Acepta") {
                                if let index = awaitingConfirmationDeliveries.firstIndex(where: { $0.id == delivery.id }) {
                                    var updatedDelivery = delivery
                                    
                                    // Assuming user is a String representing the user to be added to responsibleUsers
                                    updatedDelivery.pendingUsers.removeAll()
                                    updatedDelivery.responsibleUsers.removeAll()
                                    updatedDelivery.responsibleUsers.append(user)
                                    
                                    FirestoreManager.updateResponsibleUsers(for: updatedDelivery, with: updatedDelivery.responsibleUsers) { success in
                                        if success {
                                            // Update was successful, you can perform any additional actions here
                                            print("Responsible users updated successfully for \(delivery.direction)")
                                            self.deliveries[index] = updatedDelivery
                                        } else {
                                            // Handle the error case if the update failed
                                            print("Failed to update responsible users for \(delivery.direction)")
                                        }
                                    }
                                }
                            }
                        }
                    }
                    Button("Confirmar entrega"){
                        db.collection("deliveries").document(delivery.id).updateData([
                            "isConfirmed": true
                        ]) { error in
                            if let error = error {
                                print("Error updating delivery as completed: \(error)")
                            } else {
                                print("Delivery marked as confirmed in Firestore.")

                            }
                        }
                    }
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16))
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(8)
                }
            }
            .navigationTitle("Aceptar solicitudes")
            .onAppear {
                self.deliveries = []
                FirestoreManager.getEntregas { fetchedDeliveries in
                    self.deliveries = fetchedDeliveries
                }
            }
        }
    }
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "d MMM yy"
        return dateFormatter.string(from: date)
    }
}
    
    struct aceptarEntrega_Previews: PreviewProvider {
        static var previews: some View {
            aceptarEntrega()
        }
    }

