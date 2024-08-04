//
//  MessageBitBuilder.swift
//  SuperPage
//
//  Created by Guerson Perez on 04/08/24.
//

import Foundation

struct MessageBit: Equatable {
    
    enum CodeType: String, Codable, Equatable {
        
        case swift
        case json
        case html
        
    }
    
    enum BitType: Codable, Equatable {
        
        case text
        
        case code(CodeType)
    }
    
    var type: BitType?
    
    var text: String?
    
}

final class MessageBitBuilder {
    
}
