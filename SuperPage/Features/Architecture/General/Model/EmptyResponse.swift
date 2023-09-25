//
//  EmptyResponse.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/2/23.
//

import Foundation

enum EmptyResponseResult: String, Codable {
    case ok
}

struct EmptyResponse: Codable {
    
    var result: EmptyResponseResult?
    
    static var ok: EmptyResponse {
        var response = EmptyResponse()
        response.result = .ok
        return response
    }
}
