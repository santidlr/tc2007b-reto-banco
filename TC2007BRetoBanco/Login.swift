//
//  Login.swift
//  TC2007BRetoBanco
//

//  Created by user241186 on 10/6/23.
//

import SwiftUI

import SwiftUI

import Firebase

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    @State private var userIsLoggedIn = false
    
    
    var body: some View {
        if userIsLoggedIn {
            listaBeneficiarios()
        } else {
            content
        }
    }
    
    var content: some View {
        ZStack{
            Color.white
            
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .foregroundStyle(.linearGradient(colors: [.pink, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 1000, height: 400)
                .rotationEffect(.degrees(135))
                .offset(y: -350)
            
            VStack(spacing: 20){
                Image("logobamx")
                    .resizable()
                    .renderingMode(.original)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 170, alignment: .center)
                    .cornerRadius(5.0)
                    .shadow(radius: 10.0)
                    .offset(y: -180)
                
                Text("Bienvenido")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .frame(alignment: .center)
                    .offset(x: -80, y: -160)
                
                TextField("Email", text: $email, prompt: Text("Email").foregroundColor(.gray).bold())
                    .foregroundColor(.gray)
                    .textFieldStyle(.plain)
                    .offset(y:-80)
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                    .offset(y:-80)
                
                SecureField("Password", text: $password, prompt: Text("Password").foregroundColor(.gray).bold())
                    .foregroundColor(.gray)
                    .textFieldStyle(.plain)
                    .offset(y:-80)
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                    .offset(y:-80)
                
                Button {
                    register()
                } label: {
                    Text("Sign up")
                        .bold()
                        .frame(width: 200, height: 40)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(.linearGradient(colors: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
                        )
                        .foregroundColor(.white)
                }
                .padding(.top)
                .offset(y: 110)
                
                Button {
                    // login
                } label: {
                    Text("Already have an account? Log in")
                        .bold()
                        .foregroundStyle(.red)
                }
                .padding(.top)
                .offset(y: 110)
            }
            .frame(width: 350)
            .onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil{
                        userIsLoggedIn.toggle()
                    }
                }
            }
        }
        .ignoresSafeArea()
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
            }
        }
    }
    
    
}
    
//extension View {
//    func textoPlaceholder<Content: View>(
//    when shouldShow: Bool,
//    alignment: Alignment = .leading,
//    @ViewBuilder placeholder: () -> Content) -> some View {
//        ZStack(alignment: alignment) {
//            placeholder().opacity(shouldShow ? 1 : 0)
//            self
//        }
//    }
//}
    


struct Login_Previews: PreviewProvider {
    static var previews: some View {
        Login()
    }
}

