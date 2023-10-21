//
//  Registro.swift
//  TC2007BRetoBanco
//
//  Created by Santiago on 10/17/23.
//

import SwiftUI
import Firebase

struct Registro: View {
//    @State private var identificador = ""
    
    @State private var email = ""
    @State private var password = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var isShowingAlert = false

    @AppStorage("userIsLoggedIn") var userIsLoggedIn = false
    @AppStorage("userIsAdmin") var userIsAdmin = false
    @AppStorage("userID") var identificador = ""
    
    
    var body: some View {
        if userIsLoggedIn && !userIsAdmin{
            ContentView(id: identificador)
                .transition(.push(from: .trailing))
        } else if userIsLoggedIn && userIsAdmin {
            MenuAdminView(id: identificador)
                .transition(.push(from: .trailing))

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
                    .alert(isPresented: $isShowingAlert){ // Alert to notify the user the report creation success or failure.
                        Alert(
                            title: Text("Hubo un error al registrate"),
                            message: nil,
                            dismissButton: .default(Text("Ok"))
                        )
                    }
                }
                .padding(.top, -40)
            }
        }
//        .onAppear {
//            Auth.auth().addStateDidChangeListener { auth, user in
//                if user != nil{
//                    identificador = user!.uid
//                    withAnimation(.easeInOut(duration: 0.8)){
//                        userIsLoggedIn = true
//                    }
//                    
//                }
//            }
//        }
    }
    
    func register() {
        if email.isEmpty == true || password.isEmpty == true{
            isShowingAlert = true
        }
        else {
            if verifyEmail(email: email){
                Auth.auth().createUser(withEmail: email, password: password) { result, error in
                    if error != nil {
                        isShowingAlert = true
                        print(error!.localizedDescription)
                    } else{
                        let db = Firestore.firestore()
                        let ref = db.collection("trabajadores").document(result!.user.uid)
                        ref.setData(["email": email, "firstName": firstName, "horas": 0, "id": result!.user.uid, "lastName": lastName, "isAdmin": false]) { error in
                            if let error = error{
                                isShowingAlert = true
                                print(error.localizedDescription)
                            }
                            identificador = result!.user.uid
                            withAnimation(.easeInOut(duration: 0.8)){
                                userIsLoggedIn = true
                            }
                        }
                    }
                }
            }
            else {
                isShowingAlert = true
            }
        }
    }
    
    func verifyEmail(email: String) -> Bool{
        let emailRegex = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-][\\p{L}0-9.!#$%&'*+\\/=?^_`{|}~-]{0,63}@[\\p{L}0-9-]+(?:\\.[\\p{L}0-9-]{2,7})*$"
        
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        
        if emailPredicate.evaluate(with: email){
            return true
        }
        else{
            return false
        }
    }
}

struct Registro_Previews: PreviewProvider {
    static var previews: some View {
        LoginEdited()
    }
}
