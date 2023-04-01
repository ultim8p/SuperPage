//
//  AuthenticationInteractor.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import SwiftUI

class AuthenticationInteractor: ObservableObject {
    
    let repo: AuthenticationRepo
    
    @Published var state: AuthenticationState
    
    // MARK: Interactors
    
    @ObservedObject var userInteractor: UserInteractor
    
    @ObservedObject var env: EnvironmentInteractor
    
    @ObservedObject var chatInt: ChatInteractor
    
    init(repo: AuthenticationRepo, state: AuthenticationState) {
        self.repo = repo
        self.state = state
        userInteractor = UserInteractor.mock
        env = EnvironmentInteractor.mock
        chatInt = ChatInteractor.mock
    }
    
    func inject(env: EnvironmentInteractor,
                userInteractor: UserInteractor,
                chatInt: ChatInteractor) {
        self.env = env
        self.userInteractor = userInteractor
        self.chatInt = chatInt
    }
}
