//
//  AIModel.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

struct AIModel: Codable {
    
    enum Name: String, Codable, CaseIterable {
        
        // MARK: - OpenAI
        case gpt35Turbo = "gpt-3.5-turbo"
        
        case gpt35Turbo16k = "gpt-3.5-turbo-16k"
        
        case gpt4 = "gpt-4"
        
        case gpt432k = "gpt-4-32k"
        
        // MARK: - Claude
        case claude = "claude"
        
        case claudeInstant = "claude-instant"
    }
    
    var name: Name?
    
    var version: String?
    
    var displayName: String? {
        switch name {
        case .gpt35Turbo:
            return "GPT 3"
        case .gpt35Turbo16k:
            return "GPT 3 16k"
        case .gpt4:
            return "GPT 4"
        case .gpt432k:
            return "GPT 4 32k"
        case .claudeInstant:
            return "Claude Instant"
        case .claude:
            return "Claude"
        default:
            return nil
        }
    }
    
    static var allModels: [AIModel] {
        let allNames = Name.allCases
        var models: [AIModel] = []
        for name in allNames {
            models.append(AIModel(name: name))
        }
        return models
    }
}
