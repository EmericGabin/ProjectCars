//
//  CarsApp.swift
//  Cars
//
//  Created by emeric on 10/02/2022.
//

import SwiftUI
import Firebase

@main
struct CarsApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
