//
//  Settings.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/30/23.
//

import Foundation

struct SettingsUsage: Codable {
    
    var usage: Usage?
    
    var tokens: Tokens?
    
    var tokensPurchased: Double {
        tokens?.purchased ?? 0
    }
    
    var tokensUsed: Double {
        usage?.tokens?.totalTokens ?? 0
    }
    
    var tokensLeft: Double {
        tokensPurchased - tokensUsed
    }
    
    var shouldShowTokensLeft: Bool {
//        tokensLeft < 1_000_000
        return true
    }
}
