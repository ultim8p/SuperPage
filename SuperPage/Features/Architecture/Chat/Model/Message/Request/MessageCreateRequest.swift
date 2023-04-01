//
//  MessageCreateRequest.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

struct MessagesCreateRequestContext: Codable {
    
    var branch: BranchReference?
    
    var systemMessage: String?
    
    var useBranch: Bool?
}

struct MessagesCreateRequest: Codable {
    
    var context: MessagesCreateRequestContext?
    
    var messages: [Message]?
    
    var model: AIModel?
    
}
