//
//  AuthenticationResponse.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import NoAuth

struct SignInResponse: Codable {
    
    var user: User?
    
    var credentials: ClientCredentials?
}
