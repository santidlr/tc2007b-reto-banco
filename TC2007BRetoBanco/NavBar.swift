//
//  NavBar.swift
//  Home
//
//  Created by gdaalumno on 05/10/23.
//

import SwiftUI

var Gray = Color(red: 174 / 255, green: 168 / 255 , blue: 171 / 255)

struct NavBar: View {
    var body: some View {
        NavigationView{
            ZStack{
                Color.clear
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 500, height: 50)
                
                HStack(alignment: .center, spacing: 60){
                    
                    Button( action: {
                        print("Vista de Comunidades")
                    }, label: {
                        Text("Comunidad")
                            .foregroundColor(Gray)
                    })
                    
                    NavigationLink(destination: listaBeneficiarios()){
                        Text("Lista")
                            .foregroundColor(Gray)
                    }
                }
                    
            }
            .frame(maxHeight: .infinity, alignment: .bottom)
            
        }
    }
}

struct NavBar_Previews: PreviewProvider {
    static var previews: some View {
        NavBar()
    }
}
