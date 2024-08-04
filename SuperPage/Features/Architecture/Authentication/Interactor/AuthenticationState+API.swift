//
//  AuthenticationState+API.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import SwiftUI
import AuthenticationServices

extension AuthenticationState {
    
    func postLogin(credential: ASAuthorizationAppleIDCredential) {
        Task {
            do {
                let response = try await repo.postUserAuthenticate(env: envState, request: credential.authRequest)
                userState.setUser(response.user)
                envState.setUserCredentials(response.credentials)
                chatsState.reloadChats()
            } catch {
                print("AUTH ERR: \(error)")
            }
        }
    }
}
