//
//  UserInteractor.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import SwiftUI

class UserInteractor: ObservableObject {
    
    var repo: UserRepo
    
    @Published var state: UserState
    
    // MARK: Interactors
    
    @ObservedObject var env: EnvironmentInteractor
    
    init(repo: UserRepo, state: UserState) {
        self.repo = repo
        self.state = state
        env = EnvironmentInteractor.mock
    }
    
    func inject(env: EnvironmentInteractor) {
        self.env = env
    }
    
    func loadInitialState() {
        state.user = getUser()
    }
    
    func setUser(_ user: User?) {
        state.user = user
        let savingUser = user
        UserDefaults.standard.setObject(savingUser, forKey: "AuthenticatedUser")
    }
    
    func getUser() -> User? {
        UserDefaults.standard.getObject(forKey: "AuthenticatedUser")
    }    
}
