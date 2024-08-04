//
//  AuthenticationState.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import SwiftUI

@MainActor
class AuthenticationState: ObservableObject {
    
    let repo = AuthenticationRepo()
    
    // MARK: App State
    
    @ObservedObject var userState: UserState

    @ObservedObject var envState: EnvironmentState
    
    @ObservedObject var chatsState: ChatsState
    
    init() {
        userState = UserState.mock
        envState = EnvironmentState.mock
        chatsState = ChatsState.mock
    }
    
    func inject(
        userState: UserState,
        envState: EnvironmentState,
        chatsState: ChatsState
    ) {
        self.userState = userState
        self.envState = envState
        self.chatsState = chatsState
    }
}
