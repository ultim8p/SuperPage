//
//  AppState.swift
//  SuperPage
//
//  Created by Guerson Perez on 03/08/24.
//

import Foundation
import SwiftUI

@MainActor
class AppState: ObservableObject {
    
    // MARK: App State
    
    @ObservedObject var env = EnvironmentState.mock
    
    @ObservedObject var user = UserState.mock
    
    @ObservedObject var chats = ChatsState.mock
    
    @ObservedObject var store = StoreKitManager.mock
    
    @ObservedObject var auth = AuthenticationState.mock
    
    @ObservedObject var settings = SettingsState.mock
    
    init() {
        
    }
    
    func inject(
        evn: EnvironmentState,
        user: UserState,
        chats: ChatsState,
        store: StoreKitManager,
        auth: AuthenticationState,
        settings: SettingsState
    ) {
        self.env = env
        self.user = user
        self.chats = chats
        self.store = store
        self.auth = auth
        self.settings = settings
    }
}

extension AppState {
    
    static var mock: AppState {
        let appState = AppState()
//        appState.user = UserState.mock
        return appState
    }
}
