//
//  HomeView.swift
//  Home
//
//  Created by gdaalumno on 05/10/23.
//

import SwiftUI

let textos = Color(red: 255 / 255, green: 108 / 255, blue: 90 / 255)
let formas = Color(red: 255 / 255, green: 108 / 255, blue: 95 / 255)

struct HomeView: View {
    
    @State private var username: String = "User_0"
    @State private var identifier: String = "#12345"
    @State private var serviceHours: String = "0"
    
    var body: some View {
        VStack {
            
            Circle()
                .fill(formas)
                .frame(width: 150, height: 150)
                .padding(.bottom, 30)
            
            Text("Nombre:")
                .foregroundColor(textos)
                .padding(.leading, -150)
            
            TextField("Nombre", text: $username)
                .foregroundColor(.gray)
                .padding(.leading, 65)
                .padding(.bottom, 30)
                .disabled(true)
            
            Text("Identificador:")
                .foregroundColor(textos)
                .padding(.leading, -150)
            
            TextField("Indetificador", text: $identifier)
                .foregroundColor(.gray)
                .padding(.leading, 65)
                .padding(.bottom, 30)
                .disabled(true)
            
            Text("Horas de Servicio:")
                .foregroundColor(textos)
                .padding(.leading, -150)
            
            TextField("Horas", text: $serviceHours)
                .foregroundColor(.gray)
                .padding(.leading, 65)
                .padding(.bottom, 30)
                .disabled(true)
            
            Button( action: {
                print("Sesión Cerrada")
            }, label: {
                Text("Cerrar Sesión")
                    .foregroundColor(.white)
            })
            .frame(width: 150, height: 70)
            .background(formas)
            .cornerRadius(12)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
