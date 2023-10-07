//
//  listaBeneficiarios.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 9/30/23.
//

import SwiftUI


struct listaBeneficiarios: View {
    @State private var deliveries: [Delivery] = []
    
    var body: some View {
        NavigationStack{
            List{
                Section("Pendientes"){
                    ForEach(deliveries, id: \.self) { delivery in
                        NavigationLink(destination: detallesEntrega(delivery: delivery)){
                            LazyVGrid(columns: [
                                GridItem(.fixed(100)), // Adjust the width as needed
                                GridItem(.fixed(105)), // Adjust the width as needed
                                GridItem(.fixed(105))  // Adjust the width as needed
                            ], alignment: .leading, spacing: 5) {
                                Text("Lugar")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.orange)
                                Text("Fecha")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.orange)
                                Text("Espacios")
                                    .font(.caption)
                                    .bold()
                                    .foregroundColor(.orange)
                                Text("\(delivery.direction)")
                                    .font(.subheadline)
                                Text("\(delivery.date)")
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
}

struct listaBeneficiarios_Previews: PreviewProvider {
    static var previews: some View {
        listaBeneficiarios()
    }
}
