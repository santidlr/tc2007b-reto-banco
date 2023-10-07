//
//  homeViewModel.swift
//  TC2007BRetoBanco
//
//  Created by user246287 on 10/6/23.
//

import Foundation
import Firebase

class homeData{

    let db = Firestore.firestore()

    func fetchData(){
        db.collection("trabajadores").addSnapshotListener{ (querrySnapshot, error) in
            
        }
    }
    
}




struct  trabajadores: Hashable{
    let username: String
    let identifier: String
    let serviceHours: String
}
	
