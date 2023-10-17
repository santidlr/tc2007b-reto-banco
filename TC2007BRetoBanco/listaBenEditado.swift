//
//  listaBenEditado.swift
//  TC2007BRetoBanco
//
//  Created by user246287 on 10/16/23.
//

import SwiftUI

struct listaBenEditado: View {
        
    @State private var deliveries: [Delivery] = []
    
    // We filter deliveries in completed and not completed
    var completedDeliveries: [Delivery] {
        deliveries.filter{$0.isCompleted}
    }
    
    var pendingDeliveries: [Delivery] {
        deliveries.filter {!$0.isCompleted}
    }
    
    var body: some View{
        NavigationStack{
            
        VStack{
            // Header
            ZStack{
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 442, height: 221)
                    .background(.black)
                
                Image("banmx_beneficiarios")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 442, height: 221)
                    .opacity(0.5)
                    .clipped()
                
            }
            .edgesIgnoringSafeArea(.all)
            .frame(width: 442, height: 221)
            

            // Titulo de pagina
            Text("Tus entregas")
                .font(Font.custom("Poppins-Medium", size: 48))
                .foregroundColor(.black)
                .frame(width: 357, height: 68, alignment: .leading)
                .padding(.bottom, 30)

            
                //listaBeneficiarios View
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
                                        .font(Font.custom("PoppinsMedium", size: 15))
                                        .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                        .frame(width: 98, height: 26, alignment: .leading)
                                    
                                    Text("Fecha")
                                        .font(Font.custom("PoppinsMedium", size: 15))
                                        .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                        .frame(width: 98, height: 26, alignment: .leading)
                                        .foregroundColor(.orange)
                                    
                                    Text("Beneficiados")
                                        .font(Font.custom("PoppinsMedium", size: 15))
                                        .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                        .frame(width: 98, height: 26, alignment: .leading)
                                    
                                    Text("\(delivery.direction)")
                                        .font(Font.custom("Poppins-Regular", size: 15))
                                        .foregroundColor(.black)
                                        .frame(width: 98, height: 26, alignment: .leading)
                                    
                                    Text(formatDate(delivery.date))
                                        .font(Font.custom("Poppins-Regular", size: 15))
                                        .foregroundColor(.black)
                                        .frame(width: 98, height: 26, alignment: .leading)
                                    
                                    Text("\(delivery.numberPeople)")
                                        .font(Font.custom("Poppins-Regular", size: 15))
                                        .foregroundColor(.black)
                                        .frame(width: 98, height: 26, alignment: .leading)
                                }
                            }
                        }
                    }
                    .font(Font.custom("Poppins-Regular", size: 20))
                    .foregroundColor(.black)
                    .frame(width: 357, alignment: .leading)
                    
                    Section("Completadas"){ // Completed should not be accessible, just remove NavLink
                        ForEach(completedDeliveries, id: \.self) { delivery in
                            NavigationLink(destination: detallesEntrega(delivery: delivery)){
                                LazyVGrid(columns: [
                                    GridItem(.fixed(100)), // Why no lay properly??
                                    GridItem(.fixed(105)),
                                    GridItem(.fixed(105))
                                ], alignment: .leading, spacing: 5) {
                                    
                                    Text("Lugar")
                                        .font(Font.custom("PoppinsMedium", size: 15))
                                        .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                        .frame(width: 98, height: 26, alignment: .leading)
                                    
                                    Text("Fecha")
                                        .font(Font.custom("PoppinsMedium", size: 15))
                                        .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                        .frame(width: 98, height: 26, alignment: .leading)
                                    
                                    Text("Beneficiados")
                                        .font(Font.custom("PoppinsMedium", size: 15))
                                        .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                        .frame(width: 98, height: 26, alignment: .leading)
                                    
                                    Text("\(delivery.direction)")
                                        .font(Font.custom("Poppins-Regular", size: 15))
                                        .foregroundColor(.black)
                                        .frame(width: 98, height: 26, alignment: .leading)
                                    
                                    Text(formatDate(delivery.date))
                                        .font(Font.custom("Poppins-Regular", size: 15))
                                        .foregroundColor(.black)
                                        .frame(width: 98, height: 26, alignment: .leading)
                                    
                                    Text("\(delivery.numberPeople)")
                                        .font(Font.custom("Poppins-Regular", size: 15))
                                        .foregroundColor(.black)
                                        .frame(width: 98, height: 26, alignment: .leading)
                                }
                            }
                        }
                    }
                    .font(Font.custom("Poppins-Regular", size: 20))
                    .foregroundColor(.black)
                    .frame(width: 357, alignment: .leading)
                    .navigationTitle("")
                    .onAppear{
                        FirestoreManager.getEntregas{fetchedDeliveries in self.deliveries = fetchedDeliveries}
                    }
                }
                
            }
        }
        .background(Color(red: 0.96, green: 0.96, blue: 0.96))
    }
    
    // We format date to spanish and to the desired length
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "d MMM yy h:mm a"
        return dateFormatter.string(from: date)
    }
}



struct listaBeneEditado_Previews: PreviewProvider {
    static var previews: some View {
        listaBenEditado()
    }
}
