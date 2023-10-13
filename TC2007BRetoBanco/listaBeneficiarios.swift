//
//  listaBeneficiarios.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 9/30/23.
//

import SwiftUI


struct listaBeneficiarios: View {
    @State private var deliveries: [Delivery] = []
    
    // We filter deliveries in completed and not completed
    var completedDeliveries: [Delivery] {
        deliveries.filter{$0.isCompleted}
    }
    
    var pendingDeliveries: [Delivery] {
        deliveries.filter {!$0.isCompleted}
    }
    
    var body: some View {
        NavigationStack{
            List{
                Section("Pendientes"){
                    ForEach(pendingDeliveries, id: \.self) { delivery in
                        NavigationLink(destination: detallesEntrega(delivery: delivery)){
                            LazyVGrid(columns: [
                                GridItem(.fixed(100)), // We got rows cause it wasnt laying properly
                                GridItem(.fixed(105)),
                                GridItem(.fixed(105))
                            ], alignment: .leading, spacing: 5) {
                                Text("Lugar")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.orange)
                                Text("Fecha")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.orange)
                                Text("Beneficiados")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.orange)
                                Text("\(delivery.direction)")
                                    .font(.subheadline)
                                Text(formatDate(delivery.date))
                                    .font(.subheadline)
                                Text("\(delivery.numberPeople)")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                Section("Completadas"){ // Completed should not be accessible, just remove NavLink
                    ForEach(completedDeliveries, id: \.self) { delivery in
                        NavigationLink(destination: detallesEntrega(delivery: delivery)){
                            LazyVGrid(columns: [
                                GridItem(.fixed(100)), // Why no lay properly??
                                GridItem(.fixed(105)),
                                GridItem(.fixed(105))
                            ], alignment: .leading, spacing: 5) {
                                Text("Lugar")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.orange)
                                Text("Fecha")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.orange)
                                Text("Beneficiados")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.orange)
                                Text("\(delivery.direction)")
                                    .font(.subheadline)
                                Text(formatDate(delivery.date))
                                    .font(.subheadline)
                                Text("\(delivery.numberPeople)")
                                    .font(.subheadline)
                            }
                        }
                    }
                }
                .navigationTitle("Tus entregas")
                .onAppear{
                    FirestoreManager.getEntregas{fetchedDeliveries in self.deliveries = fetchedDeliveries}
                }
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

struct listaBeneficiarios_Previews: PreviewProvider {
    static var previews: some View {
        listaBeneficiarios()
    }
}
