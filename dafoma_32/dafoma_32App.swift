//
//  dafoma_32App.swift
//  LinguaEducate Kan
//
//  Created by Вячеслав on 8/26/25.
//

import SwiftUI

@main
struct LinguaEducateKanApp: App {
    @StateObject private var appViewModel = AppViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appViewModel)
        }
    }
}
