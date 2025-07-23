//
//  Containers.swift
//  NavigationTheBeast
//
//  Created by Anton Reasin on 22.07.2025.
//

import SwiftUI

// MARK: - Main Container (только контент без TabBar)
struct MainContainer: View {
    @EnvironmentObject var nav: NavigationManager
    
    var body: some View {
        Group {
            switch nav.currentRoute {
            case .home:
                HomeView()
            case .search:
                SearchView()
            case .favorites:
                FavoritesView()
            case .profile:
                ProfileView()
            case .settings:
                SettingsView()
            case .detail(let id):
                DetailView(id: id)
            case .favoriteItem(let id):
                FavoriteItemView(id: id)
            case .searchResults(let query):
                SearchResultsView(query: query)
            default:
                EmptyView()
            }
        }
        .transition(.opacity)
    }
}

// MARK: - Overlay Container
struct OverlayContainer: View {
    @EnvironmentObject var nav: NavigationManager
    
    var body: some View {
        ZStack {
            // Затемнение фона
            Color.black.opacity(0.3)
                .ignoresSafeArea()
                .onTapGesture {
                    nav.hideOverlay()
                }
            
            // Контент оверлея
            Group {
                switch nav.activeOverlay {
                case .settings:
                    SettingsOverlay()
                case .filter:
                    FilterOverlay()
                case .notification:
                    NotificationOverlay()
                case .itemSettings(let id):
                    ItemSettingsOverlay(itemId: id)
                case .none:
                    EmptyView()
                }
            }
            .transition(.asymmetric(
                insertion: .scale(scale: 0.8).combined(with: .opacity),
                removal: .scale(scale: 1.1).combined(with: .opacity)
            ))
        }
    }
}
