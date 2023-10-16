//
//  listaReportes.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 10/15/23.
//

import SwiftUI

struct listaReportes: View {
    @State private var reports: [Reporte] = []
    @State private var worker: Worker? // Initialize as nil
    
    // We filter deliveries in completed and not completed
    
    var body: some View {
        NavigationStack{
            List{
                    ForEach(reports) { report in
                        LazyVGrid(columns: [
                            GridItem(.fixed(80)), // We got rows cause it wasnt laying properly
                            GridItem(.fixed(80)),
                            GridItem(.fixed(80)),
                            GridItem(.fixed(80))
                        ], alignment: .leading, spacing: 5) {
                            Text("Lugar")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.orange)
                            Text("Fecha")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.orange)
                            Text("Responsable")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.orange)
                            Text("Beneficiarios")
                                .font(.caption)
                                .bold()
                                .foregroundColor(.orange)
                            Text("\(report.direction)")
                                .font(.subheadline)
                            Text(formatDate(report.date))
                                .font(.subheadline)
                            Text("\(report.responsibleUsers[0])")
                                .font(.subheadline)
                            NavigationLink("Detalles"){
                                VStack{
                                    Text("Detalles de Reporte")
                                        .font(.largeTitle)
                                        .padding(.bottom)
                                }
                                VStack{
                                    Text(usersString(from: report.userReports))
                                }
                                Spacer()
                            }
                        }
                    }
            }
            .navigationTitle("Reportes de entrega")
            .onAppear{
                FirestoreManager.getReporte{fetchedReportes in self.reports = fetchedReportes}
            }
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
            "\(user.firstName) \(user.lastName)\nID: \(user.id)\nAttendance: \(user.attendance ? "Presente" : "Faltante")\nDespensa: \(user.despensa)"
        }.joined(separator: "\n\n")
    }
}
    
    
struct listaReportes_Previews: PreviewProvider {
    static var previews: some View {
        listaReportes()
    }
}

