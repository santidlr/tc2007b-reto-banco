//
//  Registro.swift
//  TC2007BRetoBanco
//
//  Created by Santiago on 10/17/23.
//

import SwiftUI
import Firebase

struct Registro: View {
    @State private var identificador = ""
    
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var userIsLoggedIn = false
    @State private var userIsAdmin = false
    
    
    var body: some View {
        if userIsLoggedIn {
            ContentView(id: identificador)

        } else if userIsLoggedIn && userIsAdmin {
            MenuAdminView(id: identificador)

        } else {
            content
        }
    }
    
    var content: some View {
        VStack{
            
            Spacer()
                .frame(height: 50)
            
            // Banco Image
            Image("banmx_logo")
                .resizable()
                .renderingMode(.original)
                .aspectRatio(contentMode: .fit)
                .frame(width: 111, height: 70)
                .padding(.leading, 200)
            
            Spacer()
                .frame(height: 30)
            
            VStack{
                // Titulo de pagina
                Text("Registro")
                    .font(Font.custom("Poppins-Regular", size: 48))
                    .foregroundColor(.black)
                    .frame(width: 357, height: 68, alignment: .leading)
                    .padding(.bottom, 30)
                
            }
            
        
            // Spacer
            Spacer()
                .frame(height: 10)
            
            // Cuadro Rojo
            ZStack{
                
                // Rectangulo rojo
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 445, height: 590)
                  .background(
                    LinearGradient(
                        stops: [
                        Gradient.Stop(color: Color(red: 0.81, green: 0.05, blue: 0.18), location: 0.00),
                        Gradient.Stop(color: Color(red: 0.81, green: 0.05, blue: 0.18), location: 1.00),
                        ],
                        startPoint: UnitPoint(x: 0.5, y: 0),
                        endPoint: UnitPoint(x: 0.5, y: 1)
                    )
                  )
                
                // Text field y botones
                VStack{
                    
                    VStack{
                        // Email
                        TextField("Email", text: $email, prompt: Text("Email")
                            .foregroundColor(.white).bold())
                            .foregroundColor(.white)
                            .font(Font.custom("Popins-Regular", size: 20))
                            .textFieldStyle(.automatic)
                            .padding(.leading, 45)
                        
                        // Linea Email
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 357, height: 1)
                          .background(Color(red: 0.67, green: 0.67, blue: 0.67))
                        
                    }
                    .frame(alignment: .leading)
                    
                    // Spacer entre email y password
                    Spacer()
                        .frame(height: 50)
                    
                    VStack{
                        
                        // Password
                        SecureField("Password", text: $password, prompt: Text("Password")
                            .foregroundColor(.white).bold())
                            .foregroundColor(.white)
                            .font(Font.custom("Popins-Regular", size: 20))
                            .textFieldStyle(.automatic)
                            .padding(.leading, 45)
                        
                        // Linea password
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 357, height: 1)
                          .background(Color(red: 0.67, green: 0.67, blue: 0.67))
                        
                    }
                    .frame(alignment: .leading)
                    
                    // Spacer entre password y firstName
                    Spacer()
                        .frame(height: 50)
                    
                    //Entrada firstName
                    VStack{
                        // Email
                        TextField("firstName", text: $firstName, prompt: Text("Nombre(s)")
                            .foregroundColor(.white).bold())
                            .foregroundColor(.white)
                            .font(Font.custom("Popins-Regular", size: 20))
                            .textFieldStyle(.automatic)
                            .padding(.leading, 45)
                        
                        // Linea Email
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 357, height: 1)
                          .background(Color(red: 0.67, green: 0.67, blue: 0.67))
                        
                    }
                    .frame(alignment: .leading)
                    
                    // Spacer entre password y firstName
                    Spacer()
                        .frame(height: 50)
                    
                    //Entrada firstName
                    VStack{
                        // Email
                        TextField("lastName", text: $lastName, prompt: Text("Apellido(s)")
                            .foregroundColor(.white).bold())
                            .foregroundColor(.white)
                            .font(Font.custom("Popins-Regular", size: 20))
                            .textFieldStyle(.automatic)
                            .padding(.leading, 45)
                        
                        // Linea Email
                        Rectangle()
                          .foregroundColor(.clear)
                          .frame(width: 357, height: 1)
                          .background(Color(red: 0.67, green: 0.67, blue: 0.67))
                        
                    }
                    .frame(alignment: .leading)
                    
                    //Spacer entre lastName y botón Iniciar sesión
                    Spacer()
                        .frame(height: 80)
                    
                    // Register
                    Button {
                        print("Registro")
                        register()
                    } label: {
                        ZStack{
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: 267, height: 68)
                              .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                              .cornerRadius(5)
                            
                            Text("Regístrate")
                                .font(Font.custom("Poppins-Regular", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .frame(width: 267, height: 68, alignment: .center)
                        }
                        .frame(width: 267, height: 68)
                    }
                }
                .padding(.top, -40)
            }
        }
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil{
                    userIsLoggedIn.toggle()
                    identificador = user!.uid
                }
            }
        }
    }
    
    func register() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil {
                print(error!.localizedDescription)
            } else{
                let db = Firestore.firestore()
                let ref = db.collection("trabajadores").document(result!.user.uid)
                ref.setData(["email": result!.user.email!, "firstName": firstName, "horas": 0, "id": result!.user.uid, "lastName": lastName, "isAdmin": false]) { error in
                    userIsLoggedIn.toggle()
                    if let error = error{
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
}

struct Registro_Previews: PreviewProvider {
    static var previews: some View {
        LoginEdited()
    }
}
