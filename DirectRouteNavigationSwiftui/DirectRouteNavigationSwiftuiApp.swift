//
//  NavigationTheBeastApp.swift
//  NavigationTheBeast
//
//  Created by Anton Reasin on 22.07.2025.
//

import SwiftUI

@main
struct DirectRouteNavigationSwiftuiApp: App {
    @StateObject private var navigationManager = NavigationManager.shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(navigationManager)
        }
    }
}
