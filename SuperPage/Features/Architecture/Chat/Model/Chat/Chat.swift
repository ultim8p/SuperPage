//
//  Chat.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

struct Chat: Codable, Identifiable, Equatable {
    
    var id: String {
        return _id ?? UUID().uuidString
    }
    
    var _id: String?
    
    var dateCreated: Date?
    
    var dateUpdated: Date?
    
    var user: User?
    
    var name: String?
}

// MARK: - Model Read & Write

extension Array where Element == Chat {
    
    func chat(for id: String?) -> (chat: Chat, index: Int)? {
        guard let chatIndex = self.firstIndex(where: { $0._id == id}) else { return nil }
        return (self[chatIndex], chatIndex)
    }
}

// MARK: - Updating Model

extension Array where Element == Chat {
    
    // MARK: Chat
    
    mutating func setChat(name: String, chat: Chat) {
        guard let chatQ = self.chat(for: chat._id) else { return }
        self[chatQ.index].name = name
    }
}
