//
//  TC2007BRetoBancoApp.swift
//  TC2007BRetoBanco
//
//  Created by Santiago De Lira Robles on 28/09/23.
//

import SwiftUI
import Firebase

@main
struct TC2007BRetoBancoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            LoginEdited()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}
