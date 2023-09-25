//
//  MessageDraft.swift
//  SuperPage
//
//  Created by Guerson Perez on 9/25/23.
//

import Foundation

struct MessageDraft: Codable, Identifiable {
    
    var id: String {
        return _id ?? UUID().uuidString
    }
    
    var _id: String?
    
    var dateCreated: Date?
    
    var dateUpdated: Date?
    
    var user: User?
    
    var chat: Chat?
    
    var branch: Branch?
    
    var messages: [Message]?
}
