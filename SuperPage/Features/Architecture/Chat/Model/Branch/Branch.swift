//
//  Branch.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

struct Branch: Codable, Identifiable {
    
    var id: String {
        return _id ?? UUID().uuidString
    }
    
    var _id: String?
    
    var dateCreated: Date?
    
    var dateUpdated: Date?
    
    var user: User?
    
    var chat: Chat?
    
    var branch: BranchReference?
    
    var message: MessageReference?
    
    var name: String?
    
    init(_id: String? = nil,
         dateCreated: Date? = nil,
         dateUpdated: Date? = nil,
         user: User? = nil,
         chat: Chat? = nil,
         branch: BranchReference? = nil,
         message: MessageReference? = nil,
         name: String? = nil) {
        self._id = _id
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.user = user
        self.chat = chat
        self.branch = branch
        self.message = message
        self.name = name
    }
}
