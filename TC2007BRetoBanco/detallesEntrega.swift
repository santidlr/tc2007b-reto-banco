//
//  detallesEntrega.swift
//  TC2007BRetoBanco
//
//  Created by user241186 on 10/5/23.
//

import SwiftUI

struct detallesEntrega: View {
    let delivery: Delivery
    @State private var users: [User] = []

    var body: some View {
        VStack {
            Text("Delivery Details")
                .font(.largeTitle)
                .padding()
            
            // Display delivery details here (e.g., delivery.direction, delivery.date, etc.)
            
            Text("Users in Delivery:")
                .font(.headline)
                .padding(.top)
            
            List(users, id: \.id) { user in
                VStack(alignment: .leading) {
                    Text("\(user.firstName) \(user.lastName)")
                        .font(.subheadline)
                    // You can display more user information here if needed
                }
            }
        }
    }
}
