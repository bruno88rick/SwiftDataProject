//
//  SwiftDataProjectApp.swift
//  SwiftDataProject
//
//  Created by Bruno Oliveira on 18/06/24.
//

import SwiftData
import SwiftUI

@main
struct SwiftDataProjectApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: User.self)
    }
}
