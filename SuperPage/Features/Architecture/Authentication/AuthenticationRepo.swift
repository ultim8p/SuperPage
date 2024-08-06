//
//  AuthenticationRepo.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import NoAuth
import NoAPI

enum AuthPath: APIPath {
        
    case postSignIn
    
    var description: String {
        switch self {
        case .postSignIn:
            return "/v1/user/signin"
        }
    }
}

class AuthenticationRepo {
    
    func postUserAuthenticate(
        env: EnvironmentState,
        request: SignInRequest
    ) async throws -> SignInResponse {
        return try await request.request(
            env,
            method: .post,
            path: AuthPath.postSignIn,
            scheme: env.scheme,
            host: env.host,
            port: env.port
        )
        .authenticate(env: env).responseValue()
    }
}
