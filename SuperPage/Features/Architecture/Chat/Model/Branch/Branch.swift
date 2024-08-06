//
//  Branch.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

struct Branch: Codable, Identifiable, Equatable {
    
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
    
    var promptRole: Role?
    
    var name: String?
    
    var state: BranchState?
    
    var createMessageError: NoError?
    
    // MARK: - Local
    
    init(_id: String? = nil,
         dateCreated: Date? = nil,
         dateUpdated: Date? = nil,
         user: User? = nil,
         chat: Chat? = nil,
         branch: BranchReference? = nil,
         message: MessageReference? = nil,
         promptRole: Role? = nil,
         name: String? = nil,
         createMessageError: NoError? = nil) {
        self._id = _id
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.user = user
        self.chat = chat
        self.branch = branch
        self.message = message
        self.promptRole = promptRole
        self.name = name
        self.createMessageError = createMessageError
    }
}

extension Branch {
    
    var promptText: String? {
        promptRole?.text
    }
    
    var promptEmoj: String? {
        promptRole?.tags?.first?.value
    }
    
    var hasPromptText: Bool {
        promptText != nil
    }
    
    var hasPromptEmoji: Bool {
        promptEmoj != nil
    }
}
