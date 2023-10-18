//
//  elegirEntrega.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 10/16/23.
//

import SwiftUI
import Firebase

struct elegirEntrega: View {
        let db = Firestore.firestore()
        let userID = "LAUugL9aU8XrAcpGVAEDhjD451q1"
        @State private var availableDeliveries: [Delivery] = []
            
        // We filter deliveries in completed and not completed
        var deliveriesFiltered: [Delivery] {
            availableDeliveries.filter{!$0.isConfirmed}
        }
    
        var body: some View {
            NavigationStack{
                List{
                        ForEach(deliveriesFiltered, id: \.id) { deliveryxd in
                                LazyVGrid(columns: [
                                    GridItem(.fixed(80)), // Why no lay properly??
                                    GridItem(.fixed(80)),
                                    GridItem(.fixed(80)),
                                    GridItem(.fixed(70))
                                ], alignment: .leading, spacing: 5) {
                                    Text("Lugar")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.orange)
                                    Text("Fecha")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.orange)
                                    Text("Lugares")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.orange)
                                    Text("Aplicar")
                                        .font(.caption)
                                        .bold()
                                        .foregroundColor(.orange)
                                    Text("\(deliveryxd.direction)")
                                        .font(.subheadline)
                                    Text(formatDate(deliveryxd.date))
                                        .font(.subheadline)
                                    Text("\(deliveryxd.spots)")
                                        .font(.subheadline)
                                    Button(action: {
                                        if let index = deliveriesFiltered.firstIndex(where: { $0.id == deliveryxd.id }) {
                                            var updatedDelivery = deliveryxd
                                            updatedDelivery.pendingUsers.removeAll()
                                            updatedDelivery.pendingUsers.append(userID)
                                            FirestoreManager.updatePendingUsers(for: updatedDelivery, with: updatedDelivery.pendingUsers) { success in
                                                if success {
                                                    // Update was successful, you can perform any additional actions here
                                                    print("Pending users updated succesfully for \(deliveryxd.direction)")
                                                    self.availableDeliveries[index] = updatedDelivery
                                                } else {
                                                    // Handle the error case if the update failed
                                                    print("Failed to update pending users for \(deliveryxd.direction)")
                                                }
                                            }
                                        }
                                    }){
                                        let isUserPending = deliveryxd.pendingUsers.contains(userID)
                                        Text(isUserPending ? "Pendiente" : (deliveryxd.responsibleUsers.contains(userID) ? "Aprobado" : "Aplicar"))
                                            .font(.subheadline)
                                            .foregroundColor(.white)
                                            .background(isUserPending ? Color.orange : (deliveryxd.responsibleUsers.contains(userID) ? Color.green : Color.red))
                                            .cornerRadius(10)
                                    }
                            }
                        }
                }
                .navigationTitle("Aplicar a entrega")
                .onAppear{
                        self.availableDeliveries = []
                        FirestoreManager.getEntregas{fetchedDeliveries in self.availableDeliveries = fetchedDeliveries}
                }
            }
        }
        // We format date to spanish and to the desired length
        func formatDate(_ date: Date) -> String {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "es_ES")
            dateFormatter.dateFormat = "d MMM yy h:mm a"
            return dateFormatter.string(from: date)
        }
    }
    


struct elegirEntrega_Previews: PreviewProvider {
    static var previews: some View {
        elegirEntrega()
    }
}
