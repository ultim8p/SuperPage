//
//  ChatInteractor.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation
import SwiftUI

class ChatInteractor: ObservableObject {
    
    let repo: ChatRepo
    
    @Published var chats: [Chat] = []
    
    @Published var drafts: [String: MessageDraft] = [:]
    
    @ObservedObject var env: EnvironmentInteractor
    
    init(repo: ChatRepo) {
        self.repo = repo
        env = EnvironmentInteractor.mock
    }
    
    func inject(env: EnvironmentInteractor) {
        self.env = env
    }
    
    func saveBranchSettings(id: String, settings: [String: Any]) {
        UserDefaults.standard.set(settings, forKey: "chatSettings\(id)")
    }
    
    func branchSettings(id: String) -> [String: Any] {
        return UserDefaults.standard.dictionary(forKey: "chatSettings\(id)") ?? [:]
    }
}

// MARK: - Model Read & Write

extension ChatInteractor {
    
    func chat(for id: String?) -> (chat: Chat, index: Int)? {
        chats.chat(for: id)
    }
    
    func branch(for branch: Branch?) -> (chat: Chat, chatIndex: Int, branch: Branch, branchIndex: Int)? {
        chats.branch(for: branch)
    }
    
    func branch(id: Branch.ID) -> Branch? {
        chats.branch(id: id)
    }
}

// MARK: - Updating Model

extension ChatInteractor {
    
    // MARK: Chat
    
    func setChat(name: String, chat: Chat) {
        var chats = self.chats
        chats.setChat(name: name, chat: chat)
        self.chats = chats
    }
    
    func setState(chat: Chat?, state: ModelState) {
        var chats = self.chats
        chats.setState(chat: chat, state: state)
        self.chats = chats
    }
    
    func setState(chatId: String?, state: ModelState) {
        var chats = self.chats
        chats.setState(chatId: chatId, state: state)
        self.chats = chats
    }
    
    // MARK: Branch
    
    func setState(branch: Branch?, state: BranchState? = nil, loadingState: ModelState? = nil) {
        var chats = self.chats
        chats.setState(branch: branch, state: state, loadingState: loadingState)
        self.chats = chats
    }
    
    
    func setError(branch: Branch?, createMessageError: NoError?) {
        var chats = self.chats
        chats.setError(branch: branch, createMessageError: createMessageError)
        self.chats = chats
    }
    
    func setBranches(response: [Branch]) {
        var chats = self.chats
        chats.setBranches(response: response)
        self.chats = chats
    }
    
    func setBranch(name: String, branch: Branch) {
        var chats = self.chats
        chats.setBranch(name: name, branch: branch)
        self.chats = chats
    }
    
    func addBranch(_ branch: Branch) {
        var chats = self.chats
        chats.addBranch(branch)
        self.chats = chats
    }
    
    func remove(branch: Branch) {
        var chats = self.chats
        chats.remove(branch: branch)
        self.chats = chats
    }
    
    // MARK: Messages
    
    func setMessages(messages: [Message], branch: Branch) {
        var chats = self.chats
        chats.setMessages(messages: messages, branch: branch)
        self.chats = chats
    }
    
    func addMessage(messages: [Message], branch: Branch) {
        var chats = self.chats
        chats.addMessage(messages: messages, branch: branch)
        self.chats = chats
    }
    
    func removeMessage(message: Message) {
        var chats = chats
        chats.removeMessage(message: message)
        self.chats = chats
    }
}

// MARK: - Actions

extension ChatInteractor {
    
    func toggleExpand(chat: Chat) {
        var chats = self.chats
        guard let chatIndex = chats.firstIndex(where: { $0._id == chat._id }) else { return }
        var updatingChat = chats[chatIndex]
        updatingChat.expanded = !(updatingChat.expanded ?? false)
        chats[chatIndex] = updatingChat
        self.chats = chats
        
        if updatingChat.expanded ?? false {
            getBranches(chat: chat)
        }
    }
    
    func remove(chat: Chat) {
        guard let chatIndex = chats.firstIndex(where: {$0.id == chat.id}) else { return }
        chats.remove(at: chatIndex)
    }
}
