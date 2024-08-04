//
//  Message.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

struct Message: Codable, Identifiable, Equatable {
    
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
    
    var content: [MessageContent]?
    
    var model: AIModel?
    
    // Local
    
    
    init(_id: String? = nil,
         dateCreated: Date? = nil,
         dateUpdated: Date? = nil,
         user: User? = nil,
         chat: Chat? = nil,
         branch: Branch? = nil,
         role: ChatRole? = nil,
         content: [MessageContent]? = nil,
         model: AIModel? = nil) {
        self._id = _id
        self.dateCreated = dateCreated
        self.dateUpdated = dateUpdated
        self.user = user
        self.chat = chat
        self.branch = branch
        self.role = role
        self.content = content
        self.model = model
    }
    
    func fullTextValue() -> String? {
        content?.first?.texts?.first
    }
}

extension Message {
    
    static func create(role: ChatRole?, text: String?, model: AIModel? = nil) -> Message {
        
        var messagesContent: [MessageContent] = []
        if let text {
            messagesContent.append(MessageContent(type: .text, texts: [text]))
        }
        
        return Message(
            role: role,
            content: messagesContent,
            model: model
        )
    }
    
    var hasText: Bool {
        let textContent = content?.first(where: { !($0.texts?.first?.isEmpty ?? true) })
        return textContent != nil
    }
}

extension Message {
    
    mutating func updateFirstContent(text: String?) {
        guard let text else { return }
        var contents = content ?? []
        var obj = contents.first ?? MessageContent(type: .text, texts: [text])
        if contents.isEmpty {
            contents.append(obj)
        } else {
            contents[0] = obj
        }
        self.content = contents
    }
}
