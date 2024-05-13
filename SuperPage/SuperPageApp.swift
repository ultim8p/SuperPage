//
//  SuperPageApp.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import SwiftUI

@main
struct SuperPageApp: App {
    
    // MARK: - Interactor
    @StateObject var userInteractor = UserInteractor(
        repo: UserRepo(),
        state: UserState())
    
    @StateObject var signInInteractor = AuthenticationInteractor(
        repo: AuthenticationRepo(),
        state: AuthenticationState())
    
    //@StateObject var chatInteractor = ChatInteractor(repo: ChatRepo())
    @StateObject var chatInteractor = ChatInteractor.mock
    
    @StateObject var settingsInt = SettingsInteractor(repo: SettingsRepo())
    
    @StateObject var env = EnvironmentInteractor(
        state: EnvironmentState())
    
    @StateObject var store = StoreKitManager(identifiers: StoreProduct.rawValues)
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userInteractor)
                .environmentObject(signInInteractor)
                .environmentObject(chatInteractor)
                .environmentObject(settingsInt)
                .environmentObject(store)
                .onAppear {
                    setupInjection()
                }
        }
        #if os(macOS)
        .windowStyle(HiddenTitleBarWindowStyle())
        #endif
    }
}

extension SuperPageApp {
    
    func setupInjection() {
        signInInteractor.inject(
            env: env,
            userInteractor: userInteractor,
            chatInt: chatInteractor)
        userInteractor.inject(env: env)
        chatInteractor.inject(
            env: env,
            settingsInt: settingsInt
        )
        settingsInt.inject(env: env)
        
        userInteractor.loadInitialState()
        env.loadInitialState()
        chatInteractor.reloadChats()
        settingsInt.loadInitialState()
        
        Task {
            await self.store.fetchProducts()
        }
    }
}
