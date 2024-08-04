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
    
    // MARK: Local
    
    var state: ModelState?
    
    var branches: [Branch]?
    
    var expanded: Bool?
}

// MARK: - Model Read & Write

extension Array where Element == Chat {
    
    func chat(for id: String?) -> (chat: Chat, index: Int)? {
        guard let chatIndex = self.firstIndex(where: { $0._id == id}) else { return nil }
        return (self[chatIndex], chatIndex)
    }
    
    func branch(for branch: Branch?) -> (chat: Chat, chatIndex: Int, branch: Branch, branchIndex: Int)? {
        guard
            let chatQ = chat(for: branch?.chat?._id),
            let branchIndex = chatQ.chat.branches?.firstIndex(where: { $0._id == branch?._id }),
            let branch = chatQ.chat.branches?[branchIndex]
        else { return nil }
        
        return (chatQ.chat, chatQ.index, branch, branchIndex)
    }
    
    func branch(id: Branch.ID) -> Branch? {
        for chat in self {
            for branch in chat.branches ?? [] {
                if branch.id == id { return branch }
            }
        }
        return nil
    }
}

// MARK: - Updating Model

extension Array where Element == Chat {
    
    // MARK: Chat
    
    mutating func setChat(name: String, chat: Chat) {
        guard let chatQ = self.chat(for: chat._id) else { return }
        self[chatQ.index].name = name
    }
    
    mutating func setState(chat: Chat?, state: ModelState) {
        guard let chat = chat else { return }
        setState(chatId: chat._id, state: state)
    }
    
    mutating func setState(chatId: String?, state: ModelState) {
        guard let chatId = chatId, let chatQ = self.chat(for: chatId) else { return }
        self[chatQ.index].state = state
    }
    
    // MARK: Branch
    
    mutating func setState(
        branch: Branch?,
        state: BranchState? = nil,
        loadingState: ModelState? = nil
    ) {
        guard
            let branch = branch,
            let branchQ = self.branch(for: branch)
        else { return }
        if let state {
            self[branchQ.chatIndex].branches?[branchQ.branchIndex].state = state
        }
        if let loadingState {
            self[branchQ.chatIndex].branches?[branchQ.branchIndex].loadingState = loadingState
        }
    }
    
    mutating func update(branch: Branch?) {
        guard
            let branch,
            var branchQ = self.branch(for: branch)
        else { return }
        branchQ.branch.name = branch.name
        branchQ.branch.dateUpdated = branch.dateUpdated
        branchQ.branch.promptRole = branch.promptRole
        branchQ.branch.createMessageError = branch.createMessageError
        branchQ.branch.state = branch.state
        branchQ.branch.loadingState = .ok
        self[branchQ.chatIndex].branches?[branchQ.branchIndex] = branchQ.branch
    }
    
    mutating func setError(branch: Branch?, createMessageError: NoError?) {
        guard
            let branch = branch,
            let branchQ = self.branch(for: branch)
        else { return }
        self[branchQ.chatIndex].branches?[branchQ.branchIndex].createMessageError = createMessageError
    }
    
    mutating func setBranches(response: [Branch]) {
        guard let chatId = response.first?.chat?._id, let chatQ = self.chat(for: chatId) else { return }
        self[chatQ.index].branches = response
        self[chatQ.index].state = nil
    }
    
    mutating func setBranch(name: String, branch: Branch) {
        guard let branchQ = self.branch(for: branch) else { return }
        self[branchQ.chatIndex].branches?[branchQ.branchIndex].name = name
    }
    
    mutating func addBranch(_ branch: Branch) {
        guard let chatQ = self.chat(for: branch.chat?._id) else { return }
        var branches = self[chatQ.index].branches ?? []
        if branches.isEmpty {
            branches = [branch]
        } else {
            branches.append(branch)
        }
        self[chatQ.index].branches = branches
        self[chatQ.index].state = nil
    }
    
    mutating func remove(branch: Branch) {
        guard let branchQ = self.branch(for: branch) else { return }
        self[branchQ.chatIndex].branches?.remove(at: branchQ.branchIndex)
        self[branchQ.chatIndex].state = nil
    }
    
    // MARK: Messages
    
    mutating func setMessages(messages: [Message], branch: Branch) {
        guard let branchQ = self.branch(for: branch) else { return }
        self[branchQ.chatIndex].branches?[branchQ.branchIndex].messages = messages
        self[branchQ.chatIndex].branches?[branchQ.branchIndex].loadingState = .ok
    }
    
    mutating func addMessage(messages: [Message], branch: Branch) {
        guard let branchQ = self.branch(for: branch) else { return }
        self[branchQ.chatIndex].branches?[branchQ.branchIndex].messages?.append(contentsOf: messages)
        self[branchQ.chatIndex].branches?[branchQ.branchIndex].loadingState = .ok
    }
    
    mutating func removeMessage(message: Message) {
        guard let branchQ = self.branch(for: message.branch) else { return }
        if let messageIndex = self[branchQ.chatIndex].branches?[branchQ.branchIndex].messages?.firstIndex(where: { $0._id == message._id }) {
            self[branchQ.chatIndex].branches?[branchQ.branchIndex].messages?.remove(at: messageIndex)
            self[branchQ.chatIndex].branches?[branchQ.branchIndex].loadingState = .ok
        }
    }
}
