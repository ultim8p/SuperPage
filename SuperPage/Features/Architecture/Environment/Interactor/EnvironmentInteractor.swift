//
//  EnvironmentInteractor.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import SwiftUI
import NoAuth

class EnvironmentInteractor: ObservableObject {
    
    @Published var state: EnvironmentState
    
    init(state: EnvironmentState) {
        self.state = state
    }
    
    func loadInitialState() {
        state.userCredentials = getUserCredentials()
    }
    
    func setUserCredentials(_ credentials: ClientCredentials?) {
        state.userCredentials = credentials
        UserDefaults.standard.setObject(credentials, forKey: "AuthenticatedUserCredentials")
    }
    
    func getUserCredentials() -> ClientCredentials? {
        UserDefaults.standard.getObject(forKey: "AuthenticatedUserCredentials")
    }
}
