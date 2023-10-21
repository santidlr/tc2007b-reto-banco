//
//  listaReportesEditado.swift
//  TC2007BRetoBanco
//
//  Created by user245582 on 10/18/23.
//

import SwiftUI

struct listaReportesEditado: View {
    
    @State private var reports: [Reporte] = []
    @State private var worker: Worker? // Initialize as nil
    
    // We filter deliveries in completed and not completed
    
    var body: some View {
        NavigationStack{
            VStack{
                // Header
                ZStack{
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 442, height: 221)
                        .background(.black)
                    
                    Image("banmx_reporte")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .padding(.top, 20)
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
                    Text("Lista de")
                        .font(Font.custom("Poppins-Regular", size: 48))
                        .foregroundColor(.black)
                        .frame(width: 357, height: 50, alignment: .leading)
                    
                    Text("Reportes")
                        .font(Font.custom("Poppins-Medium", size: 48))
                        .foregroundColor(.black)
                        .frame(width: 357, height: 50, alignment: .leading)
                        .padding(.bottom, 15)
                }
                
                
                List{
                    ForEach(reports) { report in
                        LazyVGrid(columns: [
                            GridItem(.fixed(80)), // We got rows cause it wasnt laying properly
                            GridItem(.fixed(80)),
                            GridItem(.fixed(80)),
                            GridItem(.fixed(80))
                        ], alignment: .leading, spacing: 5) {
                            
                            Text("Lugar")
                                .font(Font.custom("Poppins-Medium", size: 15))
                                .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                .frame(width: 50, height: 26, alignment: .center)
                            
                            Text("Fecha")
                                .font(Font.custom("Poppins-Medium", size: 15))
                                .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                .frame(width: 50, height: 26, alignment: .center)
                            
                            Text("Responsable")
                                .font(Font.custom("Poppins-Medium", size: 15))
                                .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                .frame(width: 105, height: 26, alignment: .leading)
                                .padding(.leading, -12)
                            
                            Text("Beneficiarios")
                                .font(Font.custom("Poppins-Medium", size: 15))
                                .foregroundColor(Color(red: 0.95, green: 0.6, blue: 0))
                                .frame(width: 98, height: 26, alignment: .leading)
                            
                            Text("\(report.direction)")
                                .font(Font.custom("Poppins-Regular", size: 15))
                                .foregroundColor(.black)
                                .frame(width: 80, height: 50, alignment: .leading)

                            Text(formatDate(report.date))
                                .font(Font.custom("Poppins-Regular", size: 15))
                                .foregroundColor(.black)
                                .frame(width: 80, height: 50, alignment: .leading)
                            
                            Text("\(report.responsibleUsers[0])")
                                .font(Font.custom("Poppins-Regular", size: 15))
                                .foregroundColor(.black)
                                .frame(width: 70, height: 50, alignment: .center)
                            
                            NavigationLink("Detalles"){
                                VStack{
                                    Text("Detalles de")
                                        .font(Font.custom("Poppins-Regular", size: 48))
                                        .foregroundColor(.black)
                                        .frame(width: 357, height: 68, alignment: .leading)
                                    
                                    Text("Reporte")
                                        .font(Font.custom("Poppins-Medium", size: 48))
                                        .foregroundColor(.black)
                                        .frame(width: 357, height: 68, alignment: .leading)
                                        .padding(.bottom, 30)
                                }
                                VStack{
                                    ScrollView{
                                        Text(usersString(from: report.userReports))
                                            .font(Font.custom("Poppins-Regular", size: 15))
                                            .foregroundColor(.black)
                                            .frame(width: 357, alignment: .leading)
                                    }
                                }
                            }
                        }
                    }
                }
                .navigationTitle("")
                .onAppear{
                    FirestoreManager.getReporte{fetchedReportes in self.reports = fetchedReportes}
                }
            }
            .background(Color(red: 0.96, green: 0.96, blue: 0.96))
        }
    }
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "es_ES")
        dateFormatter.dateFormat = "d MMM yy h:mm a"
        return dateFormatter.string(from: date)
    }
    func usersString(from userReports: [UserReport]) -> String {
        return userReports.map { user in
            "\(user.firstName) \(user.lastName)\nID: \(user.id)\nAsistencia: \(user.attendance ? "Presente" : "Faltante")\nDespensa: \(user.despensa)"
        }.joined(separator: "\n\n")
    }
}

struct listaReportesEditado_Previews: PreviewProvider {
    static var previews: some View {
        listaReportesEditado()
    }
}
