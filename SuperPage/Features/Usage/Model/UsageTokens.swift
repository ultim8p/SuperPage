//
//  UsageTokens.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/30/23.
//

import Foundation

struct UsageTokens: Codable {
    
    var promptTokens: Int?
    
    var completionTokens: Int?
    
    var totalTokens: Int?
}
