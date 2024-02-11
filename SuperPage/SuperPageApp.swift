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
    
    @StateObject var chatInteractor = ChatInteractor(repo: ChatRepo())
    
    @StateObject var settingsInt = SettingsInteractor(repo: SettingsRepo())
    
    @StateObject var env = EnvironmentInteractor(
        state: EnvironmentState())
    
    @StateObject var navigationManager = NavigationManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userInteractor)
                .environmentObject(signInInteractor)
                .environmentObject(chatInteractor)
                .environmentObject(settingsInt)
                .environmentObject(navigationManager)
                .onAppear {
                    setupInjection()
                }
                .sheet(
                    item: $navigationManager.editingBranch,
                    onDismiss: {},
                    content: { branch in
                        BranchEditView(
                            isCreating: branch._id == nil,
                            name: branch.name,
                            role: branch.promptRole?.text,
                            emoji: branch.promptEmoj,
                            editedHandler: { name, role, emoji in
                                if branch._id == nil {
                                    
                                } else {
                                    var tags: [Tag]?
                                    if let emoji {
                                        tags = [Tag(type: .emoji, value: emoji)]
                                    }
                                    let role = Role(tags: tags, text: role)
                                    chatInteractor.editBranch(branch: branch, name: name, promptRole: role)
                                 }
                            }
                        )
                    }
                )
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
        chatInteractor.inject(env: env)
        settingsInt.inject(env: env)
        
        userInteractor.loadInitialState()
        env.loadInitialState()
        chatInteractor.reloadChats()
    }
}
