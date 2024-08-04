//
//  ChatsState.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation
import SwiftUI

@MainActor
class ChatsState: ObservableObject {
    
    // MARK: - Network
    
    let repo = ChatRepo()
    
    // MARK: - Model State
    
    @Published var chats: [Chat] = []
    
    @Published var drafts: [String: MessageDraft] = [:]
    
    @Published var loadingChatsState: ModelState = .loading
    
    // MARK: - App State
    
    @ObservedObject var settings: SettingsState
    
    @ObservedObject var env: EnvironmentState
    
    init() {
        settings = SettingsState.mock
        env = EnvironmentState.mock
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//            self.chats = [
//                Chat(name: "Chat1"),
//                Chat(name: "Chat3",
//                     branches: [
//                        Branch(name: "Branch 1"),
//                        Branch(name: "Branch 2"),
//                        Branch(name: "Branch 3")
//                     ]),
//                Chat(name: "Chat4"),
//                Chat(name: "Chat5", branches: [Branch(name: "Branch1")])
//            ]
//            print("DID SET CHATS")
//        })
    }
    
    func inject(settings: SettingsState, env: EnvironmentState) {
        self.settings = settings
        self.env = env
    }
    
    func saveBranchSettings(id: String, settings: [String: Any]) {
        UserDefaults.standard.set(settings, forKey: "chatSettings\(id)")
    }
    
    func branchSettings(id: String) -> [String: Any] {
        return UserDefaults.standard.dictionary(forKey: "chatSettings\(id)") ?? [:]
    }
    
    var hasChats: Bool {
        !chats.isEmpty
    }
}

// MARK: - Model Read & Write

extension ChatsState {
    
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

extension ChatsState {
    
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

extension ChatsState {
    
    func remove(chat: Chat) {
        guard let chatIndex = chats.firstIndex(where: {$0.id == chat.id}) else { return }
        chats.remove(at: chatIndex)
    }
}

// MARK: - Draft

extension ChatsState {
    
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
