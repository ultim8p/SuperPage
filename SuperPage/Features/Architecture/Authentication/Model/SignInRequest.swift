//
//  AuthenticationRequest.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import AuthenticationServices


struct SignInApple: Codable {
    
    var dateCreated: Date?
    
    var dateUpdated: Date?
    
    var identityToken: Data?
    
    var authorizationCode: Data?
    
    var realUserStatus: String?
    
    var user: String?
    
    var email: String?
}

struct SignInRequest: Codable {
    
    var apple: SignInApple?
}

extension ASAuthorizationAppleIDCredential {
    
    var authRequest: SignInRequest {
        var request = SignInApple()
        request.identityToken = identityToken
        request.authorizationCode = authorizationCode
        request.realUserStatus = realUserStatus.rawValue.description
        request.user = user
        request.email = email
        return SignInRequest(apple: request)
    }
}
