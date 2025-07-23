//
//  Body.swift
//  NavigationTheBeast
//
//  Created by Anton Reasin on 22.07.2025.
//

import SwiftUI
import Combine

// MARK: - Header View
struct HeaderView: View {
    @EnvironmentObject var nav: NavigationManager
    
    var body: some View {
        HStack {
            Text("MyApp")
                .font(.title2)
                .fontWeight(.bold)
            
            Spacer()
            
            // Кнопка уведомлений
            Button(action: {
                nav.showOverlay(.notification)
            }) {
                Image(systemName: "bell")
                    .font(.title3)
            }
            .padding(.trailing, 10)
            
            // Кнопка настроек - работает откуда угодно
            Button(action: {
                nav.go(.settings)
            }) {
                Image(systemName: "gearshape")
                    .font(.title3)
            }
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: 2)
    }
}

// MARK: - Custom TabBar
struct CustomTabBar: View {
    @EnvironmentObject var nav: NavigationManager
    
    var body: some View {
        HStack(spacing: 0) {
            // Главная
            TabBarButton(
                icon: "house.fill",
                title: "Главная",
                isSelected: isHomeRoute,
                action: { nav.go(.home) }
            )
            
            // Поиск
            TabBarButton(
                icon: "magnifyingglass",
                title: "Поиск",
                isSelected: isSearchRoute,
                action: { nav.go(.search) }
            )
            
            // Избранное
            TabBarButton(
                icon: "heart.fill",
                title: "Избранное",
                isSelected: isFavoritesRoute,
                action: { nav.go(.favorites) }
            )
            
            // Профиль
            TabBarButton(
                icon: "person.fill",
                title: "Профиль",
                isSelected: isProfileRoute,
                action: { nav.go(.profile) }
            )
        }
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(Color(UIColor.systemBackground))
        .shadow(color: Color.black.opacity(0.05), radius: 2, y: -2)
    }
    
    // Проверки для подсветки активной вкладки
    var isHomeRoute: Bool {
        switch nav.currentRoute {
        case .home, .detail: return true
        default: return false
        }
    }
    
    var isSearchRoute: Bool {
        switch nav.currentRoute {
        case .search, .searchResults: return true
        default: return false
        }
    }
    
    var isFavoritesRoute: Bool {
        switch nav.currentRoute {
        case .favorites, .favoriteItem: return true
        default: return false
        }
    }
    
    var isProfileRoute: Bool {
        switch nav.currentRoute {
        case .profile, .profileWithSettings: return true
        default: return false
        }
    }
}

// MARK: - TabBar Button
struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(title)
                    .font(.caption2)
            }
            .foregroundColor(isSelected ? .blue : .gray)
            .frame(maxWidth: .infinity)
        }
    }
}



// MARK: - Views
struct HomeView: View {
    @EnvironmentObject var nav: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Главная")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            // Простые переходы
            Button("Профиль") {
                nav.go(.profile)
            }
            
            Button("Поиск") {
                nav.go(.search)
            }
            
            // Сложный переход - сразу профиль с настройками
            Button("Профиль → Настройки") {
                nav.go(.profileWithSettings)
            }
            
            // Переход к конкретному элементу с настройками
            // После закрытия настроек вернемся на главную
            Button("Избранное 5 с настройками") {
                nav.go(.favoriteItemWithSettings(id: "5"))
            }
            
            ForEach(1...5, id: \.self) { index in
                Button("Элемент \(index)") {
                    nav.go(.detail(id: "\(index)"))
                }
                .buttonStyle(.bordered)
            }
            
            Text("Текущий маршрут: \(String(describing: nav.currentRoute))")
                .font(.caption)
                .foregroundColor(.secondary)
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
    }
}

struct ProfileView: View {
    @EnvironmentObject var nav: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Профиль")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Circle()
                .fill(Color.blue)
                .frame(width: 100, height: 100)
            
            Button("Настройки") {
                nav.showOverlay(.settings)
            }
            
            Button("На главную") {
                nav.goHome()
            }
            
            Button("Избранное") {
                nav.go(.favorites)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blue.opacity(0.1))
    }
}

struct FavoritesView: View {
    @EnvironmentObject var nav: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Избранное")
                .font(.largeTitle)
                .fontWeight(.bold)
            ScrollView {
            ForEach(1...10, id: \.self) { index in
                HStack {
                    Text("Избранное \(index)")
                    Spacer()
                    Button("Открыть") {
                        nav.go(.favoriteItem(id: "\(index)"))
                    }
                    Button("⚙️") {
                        nav.go(.favoriteItemWithSettings(id: "\(index)"))
                    }
                }
                .padding()
                .background(Color.yellow.opacity(0.2))
                .cornerRadius(8)
            }
            .padding(.horizontal)
        }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.yellow.opacity(0.1))
    }
}

struct DetailView: View {
    let id: String
    @EnvironmentObject var nav: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Детали: \(id)")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Button("Показать фильтр") {
                nav.showOverlay(.filter)
            }
            
            Button("Настройки элемента") {
                nav.showOverlay(.itemSettings(itemId: id))
            }
            
            HStack {
                Button("Домой") {
                    nav.goHome()
                }
                
                Button("Профиль") {
                    nav.goProfile()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.green.opacity(0.1))
    }
}

struct SearchView: View {
    @EnvironmentObject var nav: NavigationManager
    @State private var query = ""
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Поиск")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            TextField("Поиск...", text: $query)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Искать") {
                nav.go(.searchResults(query: query))
            }
            
            Button("Фильтры") {
                nav.showOverlay(.filter)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.purple.opacity(0.1))
    }
}

struct FavoriteItemView: View {
    let id: String
    @EnvironmentObject var nav: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Избранное #\(id)")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Детальная информация об элементе")
                .foregroundColor(.secondary)
            
            Button("Настройки этого элемента") {
                nav.showOverlay(.itemSettings(itemId: id))
            }
            
            Button("Назад к списку") {
                nav.go(.favorites)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.orange.opacity(0.1))
    }
}

// MARK: - Overlays
struct SettingsOverlay: View {
    @EnvironmentObject var nav: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            HStack {
                Text("Настройки")
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button("✕") {
                    nav.hideOverlay()
                }
                .font(.title2)
            }
            .padding()
            
            Toggle("Уведомления", isOn: .constant(true))
            Toggle("Темная тема", isOn: .constant(false))
            Toggle("Автообновление", isOn: .constant(true))
            
            Spacer()
        }
        .padding()
        .frame(width: 300, height: 400)
        .background(Color.white.opacity(0.95))
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct FilterOverlay: View {
    @EnvironmentObject var nav: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Фильтры")
                .font(.title)
                .fontWeight(.bold)
            
            ForEach(["Все", "Новые", "Популярные"], id: \.self) { filter in
                Button(filter) {
                    print("Выбран фильтр: \(filter)")
                    nav.hideOverlay()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
            }
            
            Button("Закрыть") {
                nav.hideOverlay()
            }
            .foregroundColor(.red)
        }
        .padding()
        .frame(width: 280, height: 300)
        .background(Color.white.opacity(0.95))
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

struct ItemSettingsOverlay: View {
    let itemId: String
    @EnvironmentObject var nav: NavigationManager
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Настройки элемента #\(itemId)")
                .font(.title2)
                .fontWeight(.bold)
            
            Button("Удалить") {
                print("Удален элемент \(itemId)")
                nav.hideOverlay()
            }
            .foregroundColor(.red)
            
            Button("Дублировать") {
                print("Дублирован элемент \(itemId)")
                nav.hideOverlay()
            }
            
            Button("Поделиться") {
                print("Поделиться элементом \(itemId)")
            }
            
            Button("Готово") {
                nav.hideOverlay()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(width: 300, height: 350)
        .background(Color.white.opacity(0.95))
        .cornerRadius(20)
        .shadow(radius: 20)
    }
}

// Остальные View...
struct SettingsView: View {
    var body: some View {
        Text("Экран настроек")
            .font(.largeTitle)
    }
}

struct EditProfileView: View {
    var body: some View {
        Text("Редактирование профиля")
            .font(.largeTitle)
    }
}

struct SearchResultsView: View {
    let query: String
    var body: some View {
        Text("Результаты поиска: \(query)")
            .font(.largeTitle)
    }
}

struct NotificationOverlay: View {
    var body: some View {
        Text("Уведомления")
            .padding()
            .background(Color.white)
            .cornerRadius(10)
    }
}
