//
//  UserState.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import SwiftUI

@MainActor
class UserState: ObservableObject {
    
    let repo = UserRepo()
    
    // MARK: Model state
    
    @Published var user: User? = nil
    
    // MARK: App State
    
    init() {
    }
    
    func inject() {
        
    }
    
    func loadInitialState() {
        user = getUser()
    }
    
    func setUser(_ user: User?) {
        self.user = user
        let savingUser = user
        UserDefaults.standard.setObject(savingUser, forKey: "AuthenticatedUser")
    }
    
    func getUser() -> User? {
        UserDefaults.standard.getObject(forKey: "AuthenticatedUser")
    }    
}

// MARK: - Computed State

extension UserState {
    
    var isSignedIn: Bool {
        return user != nil
    }
}
