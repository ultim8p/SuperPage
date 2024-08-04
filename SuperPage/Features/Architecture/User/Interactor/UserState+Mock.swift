//
//  UserInteractor+Mock.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation

extension UserState {
    
    static var mock: UserState {
        let state = UserState()
        state.user = User(username: "guerson24")
        return state
    }
}
