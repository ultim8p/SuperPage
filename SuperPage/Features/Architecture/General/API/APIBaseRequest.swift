//
//  APIBaseRequest.swift
//  BotNotes
//
//  Created by Guerson Perez on 3/12/23.
//

import Foundation
import NoAPI

final class APIBaseRequest: APIRequestable {
    
    var scheme: String?
    
    var host: String?
    
    var path: String?
    
    var port: Int?
    
    var queryItems: [URLQueryItem]?

    var method: APIMethod?

    var cachePolicy: URLRequest.CachePolicy?

    var timeoutInterval: TimeInterval?

    var headers: [String : String]?

    var parameters: Encodable?

    var body: Data?
}
