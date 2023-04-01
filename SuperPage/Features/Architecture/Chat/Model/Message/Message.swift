//
//  Message.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

struct Message: Codable, Identifiable {
    
    var id: String {
        return _id ?? UUID().uuidString
    }
    
    var _id: String?
    
    var dateCreated: Date?
    
    var dateUpdated: Date?
    
    var user: User?
    
    var chat: Chat?
    
    var branch: Branch?
    
    var role: ChatRole?
    
    var text: String?
    
    var model: AIModel?
    
    init(_id: String? = nil,
         dateCreated: Date? = nil,
         dateUpdated: Date? = nil,
         user: User? = nil,
         chat: Chat? = nil,
         branch: Branch? = nil,
         role: ChatRole? = nil,
         text: String? = nil,
         model: AIModel? = nil) {
        self._id = _id
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.user = user
        self.chat = chat
        self.branch = branch
        self.role = role
        self.text = text
        self.model = model
    }
}
