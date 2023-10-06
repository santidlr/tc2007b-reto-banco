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
                                VStack(alignment: .leading, spacing: 6){
                                    HStack(alignment: .center, spacing: 80){
                                        Text("Lugar")
                                            .font(.caption).bold()
                                            .foregroundColor(.orange)
                                        Text("Fecha")
                                            .font(.caption).bold()
                                            .foregroundColor(.orange)
                                        Text("Espacios")
                                            .font(.caption).bold()
                                            .foregroundColor(.orange)
                                        
                                    }
                                    HStack(alignment: .center, spacing: 40){
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
                    }
                }
        .navigationTitle("Tus entregas")
        .navigationDestination(for: Delivery.self){ delivery in
            Text("Hola")
        }
        .onAppear{
            FirestoreManager.getEntregas{fetchedDeliveries in self.deliveries = fetchedDeliveries}
            }
        }
    }
}

struct listaBeneficiarios_Previews: PreviewProvider {
    static var previews: some View {
        listaBeneficiarios()
    }
}
