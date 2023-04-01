//
//  APIResponse.swift
//  BotNotes
//
//  Created by Guerson Perez on 3/12/23.
//

import Foundation
import NoAPI

extension APIResponse {
    
    func baseValidation() throws -> Self {
        return try validate(type: APIResponseError.self)
    }
    
    @MainActor
    func baseOptionalValue<Response: Codable>() throws -> Response? {
        return try baseValidation().optionalValue(decoder: JSONDecoder.mongoDecoder)
    }
    
    @MainActor
    func baseValue<Response: Codable>() throws -> Response {
        return try baseValidation().value(decoder: JSONDecoder.mongoDecoder)
    }
}
