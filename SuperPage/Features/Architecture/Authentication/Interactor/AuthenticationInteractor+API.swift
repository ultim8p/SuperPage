//
//  AuthenticationInteractor+API.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import SwiftUI
import AuthenticationServices

extension AuthenticationInteractor {
    
    func postLogin(credential: ASAuthorizationAppleIDCredential) {
        Task {
            do {
                let response = try await repo.postUserAuthenticate(env: env, request: credential.authRequest)
                userInteractor.setUser(response.user)
                env.setUserCredentials(response.credentials)
                chatInt.reloadChats()
            } catch {
                print("AUTH ERR: \(error)")
            }
        }
    }
}
