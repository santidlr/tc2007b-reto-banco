//
//  HomeView.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 10/6/23.
//

import SwiftUI
import Firebase


struct PerfilView: View {
    @AppStorage("userID") var id = ""

//    var id = ""
    
    @State private var trabajadores : [TrabajadorSocial] = []
    
    @State private var username : String = "username"
    @State private var email: String = "something@banmx.com"
    @State private var serviceHours: String = "0"
    
    @AppStorage("userIsLoggedIn") var userIsLoggedIn = false
    @AppStorage("userIsAdmin") var userIsAdmin = false
    
    @State private var isNotLogin : Bool = false
    @State private var hide : Bool = false

    var body : some View{
        NavigationStack{
            if isNotLogin{
                LoginEdited()
            }
            else{
                content
            }
        }
        .navigationBarBackButtonHidden(hide)
    }
    
    var content: some View {
        NavigationView{
            ScrollView{
                VStack{
                    
                    ZStack{
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 148, height: 148)
                          .background(Color(red: 0.95, green: 0.6, blue: 0))
                          .cornerRadius(100)
                        
                        // Icono Dummy
                        Image("person_icon")
                            .frame(width: 52, height: 52)
                            .background(.white)
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
                            hide.toggle()
                            isNotLogin.toggle()
                            userIsLoggedIn = false
                            userIsAdmin = false
                            id = ""
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


struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilView()
    }
}
