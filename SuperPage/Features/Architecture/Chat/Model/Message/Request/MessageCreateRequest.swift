//
//  MessageCreateRequest.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

struct MessagesCreateRequestContext: Codable {
    
    var systemMessage: String?
    
    var useBranch: Bool?
    
    var messageIds: [String]?
}

struct MessagesCreateRequest: Codable {
    
    var context: MessagesCreateRequestContext?
    
    var branch: BranchReference?
    
    var messages: [Message]?
    
    var model: AIModel?
    
}
