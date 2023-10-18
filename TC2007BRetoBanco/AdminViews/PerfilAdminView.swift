//
//  PerfilAdminView.swift
//  TC2007BRetoBanco
//
//  Created by user245582 on 10/18/23.
//

import SwiftUI
import Firebase

struct PerfilAdminView: View {
    var id = ""
    
    @State private var trabajadores : [TrabajadorSocial] = []
    
    @State private var username : String = "username"
    @State private var email: String = "something@banmx.com"
    @State private var serviceHours: String = "0"
    
    @State private var isNotLogin : Bool = false
    
    var body : some View{
        NavigationStack{
            if isNotLogin{
                LoginEdited()
            }
            else{
                content
            }
        }
    }
    
    
    var content: some View {
        NavigationView{
            ScrollView{
                VStack{
                    
                    ZStack{
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 148, height: 148)
                          .background(Color(red: 0, green: 0.58, blue: 0.23))
                          .cornerRadius(100)
                        
                        // Icono Dummy
                        Image("person_icon_mini")
                            .resizable()
                            .frame(width: 52, height: 52)
                            .background(.clear)
                    }
                    
                    Spacer()
                        .frame(height: 80)
                    
                    // Titulo de pagina
                    Text("Tu perfil")
                        .font(
                            Font.custom("Poppins-Medium", size: 48)
                        )
                        .foregroundColor(.black)
                        .frame(width: 357, height: 68, alignment: .leading)
                        .padding(.bottom, 30)
                        
                    Spacer()
                        .frame(height: 50)
                    
                    // Nombre
                    ZStack{
                        VStack{
                            HStack{
                                Text("Nombre")
                                    .foregroundStyle(.black)
                                
                                TextField("Nombre", text: $username)
                                    .foregroundColor(.gray)
                                    .disabled(true)
                            }
                            .font(Font.custom("Poppins-Regular", size: 20))
                            .frame(width: 357, height: 26, alignment: .leading)
                            
                            // Linea Nombre
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 357, height: 1)
                                .background(Color(red: 0.67, green: 0.67, blue: 0.67))
                        }
                    }
                    .frame(width: 358, height: 38)
                    .padding(.bottom, 30)

                    // Correo
                    ZStack{
                        VStack{
                            HStack{
                                Text("Correo")
                                    .foregroundStyle(Color.black)
                                
                                TextField("Correo", text: $email)
                                    .foregroundColor(.gray)
                                    .disabled(true)
                            }
                            .font(Font.custom("Poppins-Regular", size: 20))
                            .frame(width: 357, height: 26, alignment: .leading)
                            
                            // Linea Id
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 357, height: 1)
                                .background(Color(red: 0.67, green: 0.67, blue: 0.67))
                        }
                    }
                    .frame(width: 358, height: 38)
                    .padding(.bottom, 30)
                    
                    
                    // Horas de Servicio
                    ZStack{
                        VStack{
                            HStack{
                                Text("Horas de Servicio")
                                    .foregroundStyle(Color.black)
                                
                                TextField("Horas", text: $serviceHours)
                                    .foregroundColor(.gray)
                                    .disabled(true)
                            }
                            .font(Font.custom("Poppins-Regular", size: 20))
                            .frame(width: 357, height: 26, alignment: .leading)
                            
                            // Linea Horas
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 357, height: 1)
                                .background(Color(red: 0.67, green: 0.67, blue: 0.67))
                        }
                    }
                    .frame(width: 358, height: 38)
                    
                    Spacer()
                        .frame(height: 80)
                    
                    // Cerrar sesion
                    ZStack{
                        Button( action: {
                            logOut()
                            isNotLogin.toggle()
                        }, label: {
                            Text("Cerrar Sesión")
                                .font(Font.custom("Poppins-Regular", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .frame(width: 267, height: 68, alignment: .center)
                        })
                        .foregroundColor(.clear)
                        .frame(width: 267, height: 68)
                        .background(Color(red: 0.81, green: 0.05, blue: 0.18))
                        .cornerRadius(5)

                    }
                    .frame(width: 267, height: 68)
                    
                    Spacer()
                        .frame(height: 50)
                }
                .onAppear {
                    FirestoreManager.getInfoTrabajadorS { fetchedTrabajadores in
                        DispatchQueue.main.async {
                            self.trabajadores = fetchedTrabajadores
                            if let user = fetchedTrabajadores.first(where: { $0.id == id }) {
                                self.username = user.username + " " + user.lastName
                                self.email = user.email
                            }
                        }
                    }
                }
            }
        }
        
    }
    func logOut() {
          let firebaseAuth = Auth.auth()
          do {
            try firebaseAuth.signOut()
          } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
          }
      }
}

struct PerfilAdminView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilAdminView()
    }
}
