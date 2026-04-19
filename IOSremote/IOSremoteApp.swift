//
//  IOSremoteApp.swift
//  IOSremote
//
//  Created by Ajay Yamamoto on 2026-04-12.
//

import SwiftUI

@main
struct IOSremoteApp: App {
    @StateObject var connection = Connection()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(connection)
        }
    }
}
