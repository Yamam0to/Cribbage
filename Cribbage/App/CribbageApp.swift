//
//  CribbageApp.swift
//  Cribbage
//
//  Created by Ajay Yamamoto on 2026-04-05.
//

import SwiftUI

@main
struct CribbageApp: App {
    @StateObject var connection = Connection()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 1200, height: 900)
                .environmentObject(connection)
        }
        .windowResizability(.contentSize)
    }
}
