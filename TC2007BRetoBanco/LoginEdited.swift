//
//  LoginEdited.swift
//  TC2007BRetoBanco
//
//  Created by user246287 on 10/17/23.
//

import SwiftUI
import Firebase

struct LoginEdited: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false

    
    
    var body: some View {
        if userIsLoggedIn {
            ContentView(id: "LAUugL9aU8XrAcpGVAEDhjD451q1")
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
                .frame(height: 50)
            
            VStack{
                // Titulo de pagina
                Text("Hola,")
                    .font(Font.custom("Poppins-Regular", size: 48))
                    .foregroundColor(.black)
                    .frame(width: 357, height: 68, alignment: .leading)
                    .padding(.bottom, 30)
                
                Text("Bienvenido")
                    .font(
                        Font.custom("Poppins-Medium", size: 48)
                    )
                    .foregroundColor(.black)
                    .frame(width: 357, height: 68, alignment: .leading)
                    .padding(.bottom, 30)
            }
            
            
            // Spacer
            Spacer()
                .frame(height: 10)
            
            // Cuadro Rojo
            ZStack{
                
                // Rectangulo
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 445, height: 539)
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
                            
                            Text("Registrate")
                                .font(Font.custom("Poppins-Regular", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .frame(width: 267, height: 68, alignment: .center)
                        }
                        .frame(width: 267, height: 68)
                    }
                    
                    // Login
                    Button {
                        print("Login")
                        login()
                    } label: {
                        HStack(spacing: -1){
                            Text("¿Ya tienes una cuenta?")
                                .font(Font.custom("Poppins-Regular", size: 15))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .frame(width: 180,height: 20, alignment: .center)
                            
                            Text("Inicia sesión")
                                .font(Font.custom("Poppins-Regular", size: 15))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .underline()
                                .frame(width: 100, height: 50, alignment: .center)
                            
                        }
                        
                    }
                }
                .padding(.top, -40)
            }
        }
        
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil{
                    userIsLoggedIn.toggle()
                }
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil{
                print(error!.localizedDescription)
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
                ref.setData(["email": email, "firstName": "Pancracio", "horas": 0, "id": result!.user.uid, "lastName": "Potasio"]) { error in
                    if let error = error{
                        print(error.localizedDescription)
                    }else{
                        print("Registration successful")
                    }
                }
            }
        }
    }
}

struct LoginEdited_Previews: PreviewProvider {
    static var previews: some View {
        LoginEdited()
    }
}
