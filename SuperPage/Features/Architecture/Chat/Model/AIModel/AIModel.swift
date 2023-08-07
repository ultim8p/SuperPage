//
//  AIModel.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

enum AIModel: String, Codable {
    
    // GPT 3
    
    case gpt35turbo = "gpt-3.5-turbo"
    
    case gpt35turbo0301 = "gpt-3.5-turbo-0301"
    
    case gpt35turbo0613 = "gpt-3.5-turbo-0613"
    
    // GPT 4
    
    case gpt4 = "gpt-4"
    
    case gpt40314 = "gpt-4-0314"
    
    case gpt40613 = "gpt-4-0613"
    
    case gpt432k = "gpt-4-32k"
    
    case gpt432k0314 = "gpt-4-32k-0314"
    
    // Claude Instant
    
    case claudeInstantV1 = "claude-instant-v1"
        
    // Claude 1.3
    
    case claudeV1dot3 = "claude-v1.3"
    
    case calude1dot3 = "claude-1.3"
    
    var botName: String {
        switch self {
        case .gpt35turbo, .gpt35turbo0301, .gpt35turbo0613:
            return "GPT 3"
        case .gpt4, .gpt40314, .gpt40613:
            return "GPT 4"
        case .gpt432k, .gpt432k0314:
            return "GPT 4 32k"
        case .claudeInstantV1:
            return "Claude Instant"
        case .claudeV1dot3, .calude1dot3:
            return "Claude 1.3"
        }
    }
    
    var botNameDebug: String {
        return rawValue
    }
}
