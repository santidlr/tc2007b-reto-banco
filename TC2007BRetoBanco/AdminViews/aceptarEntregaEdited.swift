//
//  aceptarEntregaEdited.swift
//  TC2007BRetoBanco
//
//  Created by user245582 on 10/18/23.
//

import SwiftUI
import Firebase

struct aceptarEntregaEdited: View {
    
    let db = Firestore.firestore()
    @State private var deliveries: [Delivery] = []
    @State private var pendingUserNames: [String] = []
    var awaitingConfirmationDeliveries: [Delivery] {
        deliveries.filter { !$0.isConfirmed }
    }
    // Perform deduplication or filtering
    
    var body: some View {
        
        NavigationStack{
            VStack{
                // Header
                ZStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 442, height: 221)
                        .background(.black)
                    
                    // Cambiar Imagen
                    Image("banmx_entrega")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding(.top, 10)
                        .frame(width: 442, height: 221)
                        .opacity(0.5)
                        .clipped()
                    
                }
                .edgesIgnoringSafeArea(.all)
                .frame(width: 442, height: 221)
                
                Spacer()
                    .frame(height: 10)
                
                VStack{
                    // Titulo de pagina
                    Text("Aceptar")
                        .font(Font.custom("Poppins-Regular", size: 48))
                        .foregroundColor(.black)
                        .frame(width: 357, height: 50, alignment: .leading)
                    
                    Text("Entregas")
                        .font(Font.custom("Poppins-Medium", size: 48))
                        .foregroundColor(.black)
                        .frame(width: 357, height: 50, alignment: .leading)
                        .padding(.bottom, 15)
                }
                
                
                List {
                    ForEach(awaitingConfirmationDeliveries, id: \.id) { delivery in
                        LazyVGrid(columns: [
                            GridItem(.fixed(80)), // Why no lay properly??
                            GridItem(.fixed(80)),
                            GridItem(.fixed(80)),
                            GridItem(.fixed(70))
                        ], alignment: .leading, spacing: 5) {
                            HStack(spacing: 50){
                                VStack{
                                    Text("Solicitud a:")
                                        .font(Font.custom("Poppins-Medium", size: 15))
                                        .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                        .frame(width: 100, height: 25, alignment: .center)
                                    
                                    Text("\(delivery.direction)")
                                        .font(Font.custom("Poppins-Regular", size: 15))
                                        .foregroundColor(.black)
                                        .frame(width: 100, height: 50, alignment: .center)
                                }
                                .frame(width: 100, alignment: .leading)
                                
                                VStack{
                                    Text("Fecha limite para aceptar:")
                                        .font(Font.custom("Poppins-Medium", size: 15))
                                        .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                        .frame(width: 150, height: 50, alignment: .center)
                                    
                                    Text(formatDate(delivery.date))
                                        .font(Font.custom("Poppins-Regular", size: 15))
                                        .foregroundColor(.black)
                                        .frame(width: 80, height: 50, alignment: .center)
                                        .offset(y: -14)
                                }
                            }
                            .frame(width: 350, alignment: .center)
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
                                .font(Font.custom("Poppins-Medium", size: 15))
                                .foregroundColor(Color(red: 0, green: 0.58, blue: 0.23))
                                .frame(width: 100, height: 50, alignment: .center)
                            }
                            .font(Font.custom("Poppins-Medium", size: 15))
                            .foregroundColor(Color(red: 0, green: 0.58, blue: 0.23))
                            .frame(width: 300, height: 50, alignment: .center)
                        }
                        .frame(width: 350, alignment: .center)
                        
                        
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
                        .frame(width: 350, height: 50, alignment: .center)
                        .background(Color(red: 0.81, green: 0.05, blue: 0.18))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                .navigationTitle("")
                .onAppear {
                    FirestoreManager.getEntregas { fetchedDeliveries in
                        self.deliveries = fetchedDeliveries
                    }
                }
            }
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        }
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "d MMM yy"
        return dateFormatter.string(from: date)
    }
}

struct aceptarEntregaEdited_Previews: PreviewProvider {
    static var previews: some View {
        aceptarEntregaEdited()
    }
}
