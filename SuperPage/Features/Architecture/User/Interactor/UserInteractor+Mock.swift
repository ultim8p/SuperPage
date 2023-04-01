//
//  UserInteractor+Mock.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation

extension UserInteractor {
    
    static var mock: UserInteractor {
        return UserInteractor(repo: UserRepo(), state: UserState())
    }
}
