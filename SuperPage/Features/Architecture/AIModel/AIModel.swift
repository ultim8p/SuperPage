//
//  AIModel.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

struct AIModel: Codable {
    
    enum Name: String, Codable, CaseIterable, UnknownCaseRepresentable {
        
        // MARK: - OpenAI
        case gpt35Turbo = "gpt-3.5-turbo"
        
        case gpt4TurboPreview = "gpt-4-turbo-preview"
        
        // MARK: - Claude
        case claude3Opus = "claude-3-opus"
        
        case claude3Sonnet = "claude-3-sonnet"
        
        // MARK: - Mistral
        case mistralLarge = "mistral-large"
        
        
        // MARK: - Legacy
        
        case claude = "claude"
        
        case claudeInstant = "claude-instant"
        
        case gpt35Turbo16k = "gpt-3.5-turbo-16k"
        
        case gpt4 = "gpt-4"
        
        case gpt432k = "gpt-4-32k"
        
        case unknown
        
        static public var unknownCase: AIModel.Name = .unknown
    }
    
    var name: Name?
    
    var version: String?
    
    var displayName: String? {
        switch name {
        case .gpt35Turbo:
            return "GPT 3"
        case .gpt4TurboPreview:
            return "GPT 4 Turbo"
        case .mistralLarge:
            return "MistralLarge"
        case .claude3Opus:
            return "Claude Opus"
        case .claude3Sonnet:
            return "Claude Sonnet"
            
            
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
        default:
            return nil
        }
    }
    
    static var allModels: [AIModel] {
        return [
            AIModel(name: .claude3Sonnet),
            AIModel(name: .claude3Opus),
            AIModel(name: .mistralLarge),
            AIModel(name: .gpt35Turbo),
            AIModel(name: .gpt4TurboPreview)
        ]
    }
}
