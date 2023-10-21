//
//  LoginEdited.swift
//  TC2007BRetoBanco
//
//  Created by user246287 on 10/17/23.
//

import SwiftUI
import Firebase

struct LoginEdited: View {
    
//    @State private var identificador = ""
    
    
    @State private var trabajadores : [TrabajadorSocial] = []
    @State private var userName : String = "username"
    @State private var isShowingAlert = false
    
    @State private var email = ""
    @State private var password = ""
//    @State private var userIsLoggedIn = false
//    @State private var userIsAdmin = false
    @AppStorage("userIsLoggedIn") var userIsLoggedIn = false
    @AppStorage("userIsAdmin") var userIsAdmin = false
    @AppStorage("userID") var identificador = ""
    
//    @AppStorage("worker") var worker: Worker = [id: String,
//    email: String,
//    firstname: String,
//    lastName: String,
//    horas: Int]
    
    @State private var showRegistro = false
    
    
    var body: some View {
        if userIsLoggedIn && !userIsAdmin {
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
        NavigationStack {
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
                        Button(action:{login()}){
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
                        .alert(isPresented: $isShowingAlert){ // Alert to notify the user the report creation success or failure.
                            Alert(
                                title: Text("Hubo un error al iniciar sesión"),
                                message: nil,
                                dismissButton: .default(Text("Ok"))
                            )
                        }
                        
                        // Registro
                        
                        NavigationLink{
                            Registro()
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

        }
        .navigationBarBackButtonHidden(false)
        .onAppear {
            Auth.auth().addStateDidChangeListener { auth, user in
                if user != nil{
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
                        withAnimation(.easeInOut(duration: 0.8)){
                            userIsLoggedIn = true
                        }
                    }
                }
            }
        }
    }
    
    func login() {
        print("Login")
        if email.isEmpty == true || password.isEmpty == true{
            isShowingAlert = true
        }
        else{
            if verifyEmail(email: email){
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    if error != nil{
                        isShowingAlert = true
                        print(error!.localizedDescription)
                    }
                    else{
                        FirestoreManager.getWorkerByID(workerID: result!.user.uid){ worker in
                            userIsAdmin = worker!.isAdmin
                        }
                        identificador = result!.user.uid
                        withAnimation(.easeInOut(duration: 0.8)){
                            userIsLoggedIn = true
                        }
                    }
                }
            }
            else {
                isShowingAlert = true
            }
        }
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
                        ref.setData(["email": email, "firstName": "Pancracio", "horas": 0, "id": result!.user.uid, "lastName": "Potasio", "isAdmin": false]) { error in
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

struct LoginEdited_Previews: PreviewProvider {
    static var previews: some View {
        LoginEdited()
    }
}

//struct Worker: Hashable {
//    let id: String
//    let email: String
//    let firstname: String
//    let lastName: String
//    let horas: Int
//}
