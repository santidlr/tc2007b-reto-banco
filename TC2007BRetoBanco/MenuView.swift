//
//  MenuView.swift
//  TC2007BRetoBanco
//
//  Created by user246287 on 10/15/23.
//

import SwiftUI

struct MenuView: View {
    
    @State private var userName : String = "Yahir"
    
    var body: some View {
        VStack{
            
            // Usuario Icon
            ZStack{
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 68, height: 68)
                  .background(Color(red: 0.95, green: 0.6, blue: 0))
                  .cornerRadius(100)
                
                // Icono Dummy
                Image("person")
                    .frame(width: 24, height: 24)
                    .background(.white)
            }
            
            Spacer()
                .frame(height: 80)
            
            // Bienvenida
            Text( "Hola,\n\(userName)")
                .font(
                    Font.custom("Poppins", size: 48)
                        .weight(.light)
                )
                .foregroundColor(.black)
                .frame(width: 357, height: 147, alignment: .leading)
            
            
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
