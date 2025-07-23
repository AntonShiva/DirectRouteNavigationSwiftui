//
//  NavigationManager.swift
//  NavigationTheBeast
//
//  Created by Anton Reasin on 22.07.2025.
//

import SwiftUI
import Combine


// MARK: - Navigation Route
// Описываем ВСЕ возможные состояния экранов
enum Route: Equatable {
    // Простые экраны
    case home
    case search
    case favorites
    case profile
    case settings
    
    // Экраны с параметрами
    case detail(id: String)
    case favoriteItem(id: String)
    case searchResults(query: String)
    
    // Сложные комбинации - сразу несколько экранов
    case profileWithSettings  // Профиль + настройки сверху
    case favoriteItemWithSettings(id: String)  // Избранное 5 + настройки
    case detailWithFilter(id: String)  // Детали + фильтр
    
    // Любые другие комбинации...
}

// MARK: - Overlay Type
enum OverlayType: Equatable {
    case none
    case settings
    case filter
    case notification
    case itemSettings(itemId: String)
}

// MARK: - Navigation Manager
class NavigationManager: ObservableObject {
    @Published var currentRoute: Route = .home
    @Published var activeOverlay: OverlayType = .none
    
    // Запоминаем откуда пришли для составных маршрутов
    private var routeBeforeComposite: Route? = nil
    
    static let shared = NavigationManager()
    private init() {}
    
    // Прямой переход куда угодно
    func go(_ route: Route) {
        withAnimation(.easeInOut(duration: 0.15)) {
            // Проверяем, это составной маршрут или нет
            switch route {
            case .profileWithSettings:
                // Запоминаем откуда пришли
                routeBeforeComposite = currentRoute
                currentRoute = .profile
                activeOverlay = .settings
                
            case .favoriteItemWithSettings(let id):
                // Запоминаем откуда пришли
                routeBeforeComposite = currentRoute
                currentRoute = .favoriteItem(id: id)
                activeOverlay = .itemSettings(itemId: id)
                
            case .detailWithFilter(let id):
                // Запоминаем откуда пришли
                routeBeforeComposite = currentRoute
                currentRoute = .detail(id: id)
                activeOverlay = .filter
                
            default:
                // Обычный переход - очищаем сохраненный маршрут
                routeBeforeComposite = nil
                currentRoute = route
                activeOverlay = .none
            }
        }
    }
    
    // Показать оверлей
    func showOverlay(_ type: OverlayType) {
        withAnimation(.easeInOut(duration: 0.15)) {
            activeOverlay = type
        }
    }
    
    // Скрыть оверлей
    func hideOverlay() {
        withAnimation(.easeInOut(duration: 0.15)) {
            activeOverlay = .none
            
            // Если был составной маршрут - возвращаемся откуда пришли
            if let previousRoute = routeBeforeComposite {
                currentRoute = previousRoute
                routeBeforeComposite = nil
            }
        }
    }
    
    // Быстрые переходы
    func goHome() { go(.home) }
    func goProfile() { go(.profile) }
    func goSettings() { go(.settings) }
}
