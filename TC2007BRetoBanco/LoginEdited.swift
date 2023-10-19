//
//  LoginEdited.swift
//  TC2007BRetoBanco
//
//  Created by user246287 on 10/17/23.
//

import SwiftUI
import Firebase

struct LoginEdited: View {
    
    @State private var identificador = ""
    
    @State private var trabajadores : [TrabajadorSocial] = []
    @State private var userName : String = "username"
    
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    @State private var userIsAdmin = false
    
    
    var body: some View {
        if userIsLoggedIn && !userIsAdmin {
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
                            .font(Font.custom("Poppins-Regular", size: 20))
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
                            .font(Font.custom("Poppins-Regular", size: 20))
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
                    
                    // Login
                    Button {
                        print("Login")
                        login()
                    } label: {
                        ZStack{
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: 267, height: 68)
                              .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                              .cornerRadius(5)
                            
                            Text("Iniciar sesión")
                                .font(Font.custom("Poppins-Regular", size: 20))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.black)
                                .frame(width: 267, height: 68, alignment: .center)
                        }
                        .frame(width: 267, height: 68)
                    }
                    
                    // Registro
                    Button {
                        print("Registro")
                        //usar navigation algo para show registro
//                        Registro()
                        register()
                    } label: {
                        HStack(spacing: -1){
                            Text("¿No tienes una cuenta?")
                                .font(Font.custom("Poppins-Regular", size: 15))
                                .multilineTextAlignment(.center)
                                .foregroundColor(.white)
                                .frame(width: 180,height: 20, alignment: .center)
                            
                            Text("Registrarse")
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
        .navigationBarBackButtonHidden(false)
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil{
                    userIsLoggedIn.toggle()
                    identificador = user!.uid
//                    let trabajador: Worker = FirestoreManager.getWorkerByID(workerID: identificador, completion: )
                    FirestoreManager.getInfoTrabajadorS { fetchedTrabajadores in
                        DispatchQueue.main.async {
                            self.trabajadores = fetchedTrabajadores
                            if let user = fetchedTrabajadores.first(where: { $0.id == identificador }) {
                                self.userIsAdmin = user.isAdmin
                                print("id: \(identificador)")
                            }
                            
                        }
                    }
                    
                }
            }
        }
    }
    
    func login() {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if error != nil{
                userIsLoggedIn.toggle()
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
                ref.setData(["email": email, "firstName": "Pancracio", "horas": 0, "id": result!.user.uid, "lastName": "Potasio", "isAdmin": false]) { error in
                    userIsLoggedIn.toggle()
                    if let error = error{
                        print(error.localizedDescription)
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
