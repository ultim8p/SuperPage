//
//  AuthenticationInteractor+Mock.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation

extension AuthenticationInteractor {
    
    static var mock: AuthenticationInteractor {
        return AuthenticationInteractor(repo: AuthenticationRepo(), state: AuthenticationState())
    }
}
