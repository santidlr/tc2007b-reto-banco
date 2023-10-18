//
//  MenuView.swift
//  TC2007BRetoBanco
//
//  Created by user246287 on 10/15/23.
//

import SwiftUI
import Firebase

struct MenuView: View {
    var id = ""
    
    @State private var trabajadores : [TrabajadorSocial] = []
    
    @State private var userName : String = "username"
        
    var body: some View {
        NavigationStack{
            VStack{
                ScrollView{
                    
                    // Spacer
                    Spacer()
                        .frame(height: 0)
                    
                    // Usuario Icon
                    ZStack{                        
                        NavigationLink {
                            PerfilView(id: id)
                        } label: {
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 68, height: 68)
                                .background(Color(red: 0.95, green: 0.6, blue: 0))
                                .cornerRadius(40)
                        }
                        .overlay(Image("person_icon_mini")
                        .frame(width: 24, height: 24)) 
                    }
                    .padding(.leading, 300)
                    .frame(width: 68, height: 68)
                    
                    // Spacer
                    Spacer()
                        .frame(height: 100)
                    
                    // Bienvenida
                    VStack{
                        Text( "Hola,")
                            .font(Font.custom("Poppins-Light", size: 48))
                            .foregroundColor(.black)
                            .frame(width: 357, height: 50, alignment: .leading)
                        
                        
                        TextField("nombre", text: $userName)
                            .font(Font.custom("Poppins-Medium", size: 48))
                            .foregroundColor(.black)
                            .disabled(true)
                    }
                    .frame(width: 357, height: 147, alignment: .leading)
                    
                    
                    Spacer()
                        .frame(height: 30)
                    
                    // Vista de Comunidad
                    ZStack{
                        ZStack{
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 440, height: 160)
                                .background(Color(red: 0.81, green: 0.05, blue: 0.18))
                            
                            Image("banmx_comunidad")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .padding(.top, 250)
                                .frame(width: 440, height: 160)
                                .opacity(0.3)
                                .clipped()
                            
                        }
                        .frame(width: 440, height: 160)
                        
                        
                        
                         NavigationLink{
                             ElegirEntregaEdited()
                         } label: {
                             Text("Beneficiarios _")
                                 .font(.custom("Poppins-Medium", size: 20))
                                 .foregroundColor(.white)
                                 .frame(width: 330, height: 70, alignment: .topLeading)
                         }
                         
                    }
                    .frame(width: 440, height: 160)
                    .padding(.bottom, -10)
                    
                    // Vista de Lista Beneficiarios
                    ZStack{
                        ZStack{
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 440, height: 160)
                                .background(Color(red: 0.96, green: 0.96, blue: 0.96))
                            
                            Image("banmx_beneficiarios")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .padding(.top, 70)
                                .frame(width: 440, height: 159)
                                .opacity(0.40)
                                .clipped()
                            
                        }
                        .frame(width: 440, height: 160)
                        
                        NavigationLink{
                            listaBenEditado()
                        } label: {
                            Text("Beneficiarios _")
                                .font(.custom("Poppins-Medium", size: 20))
                                .foregroundColor(Color(red: 0.81, green: 0.05, blue: 0.18))
                                .frame(width: 330, height: 70, alignment: .topLeading)
                        }
                    }
                    .frame(width: 440, height: 159)
                    .padding(.bottom, -10)
                    
                    // Vista de Tips
                    ZStack{
                        ZStack{
                            Rectangle()
                                .foregroundColor(.clear)
                                .frame(width: 440, height: 160)
                                .background(Color(red: 0.81, green: 0.05, blue: 0.18))
                            
                            Image("banmx_tips")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .padding(.top, 70)
                                .frame(width: 440, height: 159)
                                .opacity(0.25)
                                .clipped()
                            
                        }
                        .frame(width: 440, height: 160)
                        
                        
                        // Cambiar button por navigationLink

                        Button(action: {
                            print("Tips _")
                        }, label: {
                            Text("")
                                .frame(width: 440, height: 159)
                        })
                        
                        Text("Tips _")
                            .font(.custom("Poppins-Medium", size: 20))
                            .foregroundColor(.white)
                            .frame(width: 330, height: 70, alignment: .topLeading)
                        
                    }
                    .frame(width: 440, height: 159)
                    
                    Spacer()
                        .frame(height: 25)
                    
                    // Logo
                    ZStack{
                        
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 440, height: 160)
                            .background(.white)
                        
                        Image("banmx_uniendoManos_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150, height: 100)
                        
                    }
                    .frame(width: 440, height: 159)
                    .onAppear {
                        FirestoreManager.getInfoTrabajadorS { fetchedTrabajadores in
                            DispatchQueue.main.async {
                                self.trabajadores = fetchedTrabajadores
                                if let user = fetchedTrabajadores.first(where: { $0.id == id }) {
                                    self.userName = user.username
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
