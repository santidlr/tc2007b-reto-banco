//
//  listaBeneficiarios.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 9/30/23.
//

import SwiftUI

let textos = Color(red: 255 / 255, green: 108 / 255, blue: 90 / 255)
let botones = Color(red: 255 / 255, green: 108 / 255, blue: 95 / 255)

struct listaBeneficiarios: View {
    
    @State private var name = ""
    @State private var lastname = " "
    
    var body: some View {
        NavigationStack(){
            VStack(alignment: .leading){
                Grid(alignment: .center, horizontalSpacing: 70, verticalSpacing: 50){
                    GridRow{
                        Text("Juan")
                            .foregroundColor(textos)
                        Image("Face")
                            .resizable()
                            .frame(width: 100, height: 100)
                    }
                    GridRow{
                        Text("Pepe")
                            .foregroundColor(textos)
                        Image("Face2")
                            .resizable()
                        .frame(width: 100, height: 100)
                    }
                    GridRow{
                        Text("Karen")
                            .foregroundColor(textos)
                        Image("Face3")
                            .resizable()
                        .frame(width: 100, height: 100)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white.ignoresSafeArea())
        }
    }
}

struct listaBeneficiarios_Previews: PreviewProvider {
    static var previews: some View {
        listaBeneficiarios()
    }
}
