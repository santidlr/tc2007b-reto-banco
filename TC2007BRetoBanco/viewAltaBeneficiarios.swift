//
//  ContentView.swift
//  Yahir
//
//  Created by user246287 on 9/29/23.
//

import SwiftUI

let textos = Color(red: 255 / 255, green: 108 / 255, blue: 90 / 255)
let botones = Color(red: 255 / 255, green: 108 / 255, blue: 95 / 255)

// La turbo cagaste, esta vista no era la que tenías que hacer


struct AltaBeneficiarios: View {
    
    @State private var name: String = ""
    @State private var lastName: String = ""
    @State private var comunity: String = ""
    @State private var benefitsNumber: Int = 0
    
    var body: some View {
        VStack {
            VStack {
                Text("Nombre(s):")
                    .padding(.leading, -170)
                    .foregroundColor(textos)

                // El textfield va a estar cargado con lo que tenga la db
                TextField("Jorge Andrés", text: $name)
                    .padding(.leading, 45)
                    .padding(.bottom, 30)

                Text("Apellidos:")
                    .padding(.leading, -170)
                    .foregroundColor(textos)
                
                // El textfield va a estar cargado con lo que tenga la db
                TextField("Gutiérrez Orozco", text: $lastName)
                    .padding(.leading, 45)
                    .padding(.bottom, 30)
                
                Text("Numero de beneficiados:")
                    .padding(.leading, -150)
                    .foregroundColor(textos)

                Stepper{
                    Text("\(benefitsNumber)")
                     } onIncrement: {
                        benefitsNumber += 1
                         if(benefitsNumber == 6){
                             benefitsNumber = 0
                         }
                     } onDecrement: {
                         benefitsNumber -= 1
                         if(benefitsNumber < 0){
                             benefitsNumber = 0
                         }
                     }
                     .padding(.leading, 45)
                     .padding(.bottom, 30)
                     .padding()
                     .foregroundColor(Color.gray)
                
                Text("Comunidad:")
                    .padding(.leading, -170)
                    .foregroundColor(textos)
                
                // El textfield va a estar cargado con lo que tenga la db
                TextField("Mesa Colorada", text: $comunity)
                    .padding(.leading, 45)
                
                
            }
            .padding(.top, 80)
            
            Spacer()
                
            
            Button( action: {
                print("Hola")
            }, label:{
                    Text("Registrar")
                    .foregroundColor(.white)
            })
            .padding(.top, 25)
            .padding(.bottom, 25)
            .padding(.horizontal, 30)
            .background(botones)
            .cornerRadius(12)
            
            Spacer()
            Spacer()
        }
        
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        AltaBeneficiarios()
    }
}
