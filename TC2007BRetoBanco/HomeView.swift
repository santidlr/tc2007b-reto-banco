//
//  HomeView.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 10/6/23.
//

import SwiftUI

let rojo = Color(red: 206 / 255, green: 14 / 255, blue: 45 / 255)
let naranja = Color(red: 241 / 255, green: 152 / 255, blue: 0 / 255)

struct HomeView: View {
    
    @State private var trabajadores : [TrabajadorSocial] = []
    
    @State private var username: String = "username"
    @State private var email: String = "something@banmx.com"
    @State private var serviceHours: String = "0"
    
    @State private var closeSession : Bool = false
    
    var body: some View{
        if closeSession {
            Login()
        }
        else {
            content
        }
    }
    
    var content: some View {
        NavigationStack{
                VStack{
                    
                    Circle()
                        .fill(naranja)
                        .frame(width: 148, height: 148)
                        .padding(.top, -160)
                        .padding(.bottom, 50)
                    
                    Text("Perfil")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(Color.black)
                        .padding(.leading, -150)
                        .padding(.bottom, 25)
                    
                    HStack{
                        Text("Nombre:")
                            .foregroundStyle(Color.black)
                        
                        TextField("Nombre", text: $username)
                            .foregroundColor(.gray)
                            .disabled(true)
                    }
                    .padding(.leading, 45)
                    .padding(.bottom, 30)
                    
                    HStack{
                        Text("Identificador:")
                            .foregroundStyle(Color.black)
                        
                        TextField("Indetificador", text: $email)
                            .foregroundColor(.gray)
                            .disabled(true)
                    }
                    .padding(.leading, 45)
                    .padding(.bottom, 30)
                    
                    HStack{
                        Text("Horas de Servicio:")
                            .foregroundStyle(Color.black)
                        
                        TextField("Horas", text: $serviceHours)
                            .foregroundColor(.gray)
                            .disabled(true)
                    }
                    .padding(.leading, 45)
                    .padding(.bottom, 65)
                    
                    Button( action: {
                        closeSession = true
                    }, label: {
                        Text("Cerrar Sesión")
                            .foregroundColor(.white)
                    })
                    .frame(width: 267, height: 68)
                    .background(rojo)
                    
                }
                .padding(.top, 80)
            }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
