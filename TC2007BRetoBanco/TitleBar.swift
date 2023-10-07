//
//  TitleBar.swift

//  TC2007BRetoBanco
//
//  Created by user241186 on 10/6/23.
//

import SwiftUI

struct TitleBar: View {
    var title = ""
    
    var body: some View {
        
        ZStack{
            Color.clear
                .background(.ultraThinMaterial)
                .blur(radius: 10)
            
            Text(title)
                .font(.largeTitle.weight(.bold))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
        }
        .frame(height: 50)
        .frame(maxHeight: .infinity, alignment: .top)
        .padding(.leading, 50)
    }
}

struct TitleBar_Preview: PreviewProvider {
    static var previews: some View {
        TitleBar(title: "Home")
    }
}
