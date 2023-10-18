//
//  ContentView.swift
//  TC2007BRetoBanco
//
//  Created by Santiago De Lira Robles on 28/09/23.
//

import SwiftUI


struct ContentView: View {
    var id = ""
    
    var body: some View {
        MenuView(id: id)
    }
}

struct ContentViewPreviews: PreviewProvider{
    static var previews: some View{
        ContentView()
    }
}


