//
//  SuperPageApp.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import SwiftUI

@main
struct SuperPageApp: App {
    
    // MARK: - App State
    
    @StateObject var state = AppState()
    
    @StateObject var env = EnvironmentState()
    
    @StateObject var user = UserState()
    
    @StateObject var chats = ChatsState()
    
    @StateObject var store = StoreKitManager()
    
    @StateObject var auth = AuthenticationState()
    
    @StateObject var settings = SettingsState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(state)
                .environmentObject(chats)
                .environmentObject(user)
                .environmentObject(store)
                .environmentObject(auth)
                .environmentObject(settings)
                .onAppear {
                    setupInjection()
                }
        }
        #if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
        #endif
    }
}

private extension SuperPageApp {
    
    func setupInjection() {
        chats.inject(settings: settings, env: env)
        settings.inject(envState: env)
        
        env.loadInitialState()
        user.loadInitialState()
        settings.loadInitialState()
        chats.reloadChats()
        
        Task {
            await store.fetchProducts()
        }
    }
}
