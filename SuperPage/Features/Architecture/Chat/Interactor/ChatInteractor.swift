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
    
    func previousChatId(from chatId: Chat.ID) -> Chat.ID? {
        let chatCount = chats.count
        guard 
            chatCount > 0,
            let chatIndex = chats.firstIndex(where: { $0.id == chatId })
        else { return nil }
        
        let previousIndex = chatIndex - 1
        guard previousIndex >= 0 else { return chats[chatCount - 1].id }
        return chats[previousIndex].id
    }
    
    func nextChatId(from chatId: Chat.ID) -> Chat.ID? {
        let chatCount = chats.count
        guard
            chatCount > 0,
            let chatIndex = chats.firstIndex(where: { $0.id == chatId })
        else { return nil }
        
        let nextIndex = chatIndex + 1
        guard nextIndex < chatCount else { return chats[0].id }
        return chats[nextIndex].id
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
    
    func updateBranch(branch: Branch) {
        var chats = self.chats
        chats.update(branch: branch)
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

// MARK: - Draft

extension ChatInteractor {
    
    func draft(for branch: Branch?) -> MessageDraft? {
        guard let branchId = branch?._id else { return nil }
        return drafts[branchId]
    }
    
    func save(draft: MessageDraft) {
        guard let branchId = draft.branch?._id else { return }
        if let existingDraft = drafts[branchId] {
            if draft.dateCreated ?? Date() > existingDraft.dateUpdated ?? Date() {
                drafts[branchId] = draft
            }
        } else {
            drafts[branchId] = draft
        }
    }
    
    func deleteDraft(branchId: String?) {
        guard let branchId else { return }
        drafts[branchId] = nil
    }
}
