//
//  ElegirEntregaEdited.swift
//  TC2007BRetoBanco
//
//  Created by user245582 on 10/18/23.
//

import SwiftUI
import Firebase

struct ElegirEntregaEdited: View {
    
    let db = Firestore.firestore()
    let userID = "LAUugL9aU8XrAcpGVAEDhjD451q1"
    @State private var availableDeliveries: [Delivery] = []
        
    // We filter deliveries in completed and not completed
    var deliveriesFiltered: [Delivery] {
        availableDeliveries.filter{!$0.isConfirmed}
    }
    
    var body: some View {
        NavigationStack{
            VStack{
                // Header
                ZStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 442, height: 221)
                        .background(.black)
                    
                    Image("banmx_comunidad")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding(.top, 200)
                        .frame(width: 442, height: 221)
                        .opacity(0.5)
                        .clipped()
                    
                }
                .edgesIgnoringSafeArea(.all)
                .frame(width: 442, height: 221)
                
                Spacer()
                    .frame(height: 30)
                
                VStack{
                    // Titulo de pagina
                    Text("Tus")
                        .font(Font.custom("Poppins-Regular", size: 48))
                        .foregroundColor(.black)
                        .frame(width: 357, height: 50, alignment: .leading)
                    
                    Text("Comunidades")
                        .font(Font.custom("Poppins-Medium", size: 48))
                        .foregroundColor(.black)
                        .frame(width: 357, height: 50, alignment: .leading)
                        .padding(.bottom, 15)
                }
                
                List{
                        ForEach(deliveriesFiltered, id: \.id) { deliveryxd in
                                LazyVGrid(columns: [
                                    GridItem(.fixed(80)), // Why no lay properly??
                                    GridItem(.fixed(80)),
                                    GridItem(.fixed(80)),
                                    GridItem(.fixed(70))
                                ], alignment: .leading, spacing: 5) {
                                    
                                    Text("Lugar")
                                        .font(Font.custom("Poppins-Medium", size: 15))
                                        .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                        .frame(width: 98, height: 26, alignment: .leading)
                                    
                                    Text("Fecha")
                                        .font(Font.custom("Poppins-Medium", size: 15))
                                        .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                        .frame(width: 98, height: 26, alignment: .leading)
                                    
                                    Text("Lugares")
                                        .font(Font.custom("Poppins-Medium", size: 15))
                                        .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                        .frame(width: 98, height: 26, alignment: .leading)
                                    
                                    Text("Aplicar")
                                        .font(Font.custom("Poppins-Medium", size: 15))
                                        .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                        .frame(width: 98, height: 26, alignment: .leading)
                                    
                                    Text("\(deliveryxd.direction)")
                                        .font(Font.custom("Poppins-Regular", size: 15))
                                        .foregroundColor(.black)
                                        .frame(width: 70, height: 50, alignment: .leading)
                                    
                                    Text(formatDate(deliveryxd.date))
                                        .font(Font.custom("Poppins-Regular", size: 15))
                                        .foregroundColor(.black)
                                        .frame(width: 98, height: 50, alignment: .leading)
                                    
                                    Text("\(deliveryxd.spots)")
                                        .font(Font.custom("Poppins-Regular", size: 15))
                                        .foregroundColor(.black)
                                        .frame(width: 70, height: 26, alignment: .center)
                                    
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
                                            .font(Font.custom("Poppins-Regular", size: 15))               .foregroundColor(.white)
                                            .frame(width: 90, height: 50)
                                            .background(isUserPending ? Color(red: 0.95, green: 0.6, blue: 0) : (deliveryxd.responsibleUsers.contains(userID) ? Color(red: 0, green: 0.58, blue: 0.23) : Color(red: 0.81, green: 0.05, blue: 0.18)))
                                            .cornerRadius(8)
                                        
                                    }
                            }
                        }
                }
                .navigationTitle("")
                .onAppear{
                        FirestoreManager.getEntregas{fetchedDeliveries in self.availableDeliveries = fetchedDeliveries}
                }
                
            }
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
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

struct ElegirEntregaEdited_Previews: PreviewProvider {
    static var previews: some View {
        ElegirEntregaEdited()
    }
}
