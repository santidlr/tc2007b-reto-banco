//
//  Login.swift
//  TC2007BRetoBanco
//
//  Created by Santiago De Lira Robles on 06/10/23.
//

import SwiftUI

struct Login: View {
    @State private var email = ""
    @State private var password = ""
    
    
    var body: some View {
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
                    .offset(y: -200)
                    
                Text("Bienvenido")
                    .foregroundColor(.white)
                    .font(.system(size: 40, weight: .bold, design: .rounded))
                    .frame(alignment: .center)
                    .offset(x: -80, y: -180)
                
                TextField("Email", text: $email, prompt: Text("Email").foregroundColor(.gray))
                
//                TextField("Email", text: $email)
//                    .foregroundColor(.white)
//                    .textFieldStyle(.plain)
//                    .textoPlaceholder(when: email.isEmpty, alignment: Alignment = .center, placeholder: () -> Text("Email")
//                                                                  .foregroundColor(.white)
//                                                                  .bold())
//                    .textoPlaceholder(when: email.isEmpty) {
//                        Text("Email")
//                            .foregroundColor(.white)
//                            .bold()
//                    }
//                    .frame(width: 350, height: 50, alignment: .center)
//                    .offset(y: -100)
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
//                SecureField("Password", text: $password)
//                    .foregroundColor(.white)
//                    .textFieldStyle(.plain)
//                    .placeholder(when: password.isEmpty) {
//                        Text("Password")
//                            .foregroundColor(.white)
//                            .bold()
//                    }
                
                Rectangle()
                    .frame(width: 350, height: 1)
                    .foregroundColor(.white)
                
//                Button {
//                    //sign up
//                } label: {
//                    Text("Sign up")
//                        .bold()
//                        .frame(width: 200, height: 40)
//                        .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
//                            .fill(.linearGradint(color: [.pink, .red], startPoint: .top, endPoint: .bottomTrailing))
//                        )
//                        .foregroundColor(.white)
            }
            .padding()
                
                Button {
                    // login
                } label: {
                    Text("Already have an account? Login")
                }
            
        }
        .ignoresSafeArea()
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
    




#Preview {
    Login()
}


