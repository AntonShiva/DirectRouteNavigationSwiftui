//
//  ContentView.swift
//  NavigationTheBeast
//
//  Created by Anton Reasin on 22.07.2025.
//

import SwiftUI

// MARK: - Content View
struct ContentView: View {
    @EnvironmentObject var nav: NavigationManager
    
    var body: some View {
        ZStack {
            // Основной контент с TabBar
            VStack(spacing: 0) {
                // Header
                HeaderView()
                
                // Основной контент
                MainContainer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                // TabBar внизу
                CustomTabBar()
            }
            
            // Оверлей поверх всего (включая TabBar)
            if nav.activeOverlay != .none {
                OverlayContainer()
            }
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(NavigationManager.shared)
}
