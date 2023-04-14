//
//  AIModel.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

enum AIModel: String, Codable {
    
    case gpt35turbo = "gpt-3.5-turbo"
    
    case gpt35turbo0301 = "gpt-3.5-turbo-0301"
    
    case claudeInstantV1 = "claude-instant-v1"
        
    case claudeV1dot3 = "claude-v1.3"
    
    var botName: String {
        switch self {
        case .gpt35turbo, .gpt35turbo0301:
            return "GPT 3"
        case .claudeInstantV1:
            return "Claude Instant"
        case .claudeV1dot3:
            return "Claude"
        }
    }
}
