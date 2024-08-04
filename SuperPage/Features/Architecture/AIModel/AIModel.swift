//
//  AIModel.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

struct AIModel: Codable, Equatable {
    
    enum Name: String, Codable, CaseIterable, UnknownCaseRepresentable {
        
        // MARK: - OpenAI
        
        case gpt35Turbo = "gpt-3.5-turbo"
        
        case gpt4o = "gpt-4o"
        
        case gpt4oMini = "gpt-4o-mini"
        
        // MARK: - Claude
        
        case claude35Sonnet = "claude-3-5-sonnet"
        
        // MARK: - Mistral
        
        case mistralLarge = "mistral-large"
        
        // MARK: - Legacy
        
        case claude = "claude"
        
        case claudeInstant = "claude-instant"
        
        case claude3Opus = "claude-3-opus"
        
        case claude3Sonnet = "claude-3-sonnet"
        
        case gpt35Turbo16k = "gpt-3.5-turbo-16k"
        
        case gpt4 = "gpt-4"
        
        case gpt432k = "gpt-4-32k"
        
        case gpt4TurboPreview = "gpt-4-turbo-preview"
        
        
        case unknown
        
        static public var unknownCase: AIModel.Name = .unknown
    }
    
    var name: Name?
    
    var version: String?
    
    var displayName: String? {
        switch name {
        case .gpt35Turbo:
            return "GPT 3"
        case .gpt4o:
            return "GPT 4o"
        case .gpt4oMini:
            return "GPT-4o-mini"
            
            
        case .mistralLarge:
            return "MistralLarge"
        
        case .claude35Sonnet:
            return "Claude 3.5 Sonnet"
            
            // MARK: - Legacy
        case .claudeInstant:
            return "Claude Instant"
        case .claude:
            return "Claude"
        case .gpt35Turbo16k:
            return "GPT 3 16k"
        case .gpt4:
            return "GPT 4"
        case .gpt432k:
            return "GPT 4 32k"
        case .gpt4TurboPreview:
            return "GPT 4 Turbo"
        case .claude3Opus:
            return "Claude Opus"
        case .claude3Sonnet:
            return "Claude Sonnet"
        default:
            return nil
        }
    }
    
    static var allModels: [AIModel] {
        return [
            AIModel(name: .gpt4oMini),
            AIModel(name: .claude35Sonnet),
            AIModel(name: .gpt4o)
        ]
    }
}
