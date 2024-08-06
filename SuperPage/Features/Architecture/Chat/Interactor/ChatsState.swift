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
    
    @Published var chatsStates: [String: ModelState] = [:]
    
    // ChatID
    @Published var branches: [String: [Branch]] = [:]
    
    // BranchID
    @Published var branchesStates: [String: ModelState] = [:]
    
    // BranchID, Message
    @Published var messages: [String: [Message]] = [:]
    
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
    
    func chatFor(id: String) -> Chat? {
        chats.first(where: { $0._id == id })
    }
    
    func chat(for id: String?) -> (chat: Chat, index: Int)? {
        chats.chat(for: id)
    }
    
//    func branch(for branch: Branch?) -> (chat: Chat, chatIndex: Int, branch: Branch, branchIndex: Int)? {
//        chats.branch(for: branch)
//    }
//    
//    func branch(id: Branch.ID) -> Branch? {
//        chats.branch(id: id)
//    }
    
    func messagesFor(branchId: String?) -> [Message] {
        guard let branchId else { return [] }
        
        return messages[branchId] ?? []
    }
    
    func branchFor(branchRef: BranchReference?) -> Branch? {
        guard 
            let chatId = branchRef?.chat?._id,
            let branchId = branchRef?._id
        else { return nil }
        
        return branches[chatId]?.first(where: { $0._id == branchId })
    }
    
    func branchLocalStateFor(branchId: String?) -> ModelState? {
        guard let branchId else { return nil }
        return branchesStates[branchId]
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

// MARK: - Chat Model Updates

extension ChatsState {
    
    // Properties
    
    func update(chat: Chat, name: String) {
        var chats = self.chats
        chats.setChat(name: name, chat: chat)
        self.chats = chats
    }
    
    // State
    
    func update(chat: Chat?, localState: ModelState) {
        update(chatId: chat?._id, localState: localState)
    }
    
    func update(chatId: String?, localState: ModelState) {
        guard let chatId else { return }
        chatsStates[chatId] = localState
    }
    
    // Actions
    
    func remove(chat: Chat) {
        guard let chatIndex = chats.firstIndex(where: {$0.id == chat.id}) else { return }
        chats.remove(at: chatIndex)
    }
}

// MARK: - Branch Modle Updates

extension ChatsState {
    
    // State
    
    func update(branch: Branch?, createMessageError: NoError?) {
        guard
            let chatId = branch?.chat?._id,
            let branchId = branch?._id,
            var chatBranches = branches[chatId],
            let index = chatBranches.firstIndex(where: { $0._id == branchId })
        else { return }
        
        var branch = chatBranches[index]
        
        guard branch.createMessageError != createMessageError
        else { return }
        
        branch.createMessageError = createMessageError
        
        chatBranches[index] = branch
        branches[chatId] = chatBranches
    }
    
    func update(branch: Branch?, state: BranchState?) {
        guard
            let chatId = branch?.chat?._id,
            let branchId = branch?._id
        else { return }
        
        var chatBranches = branches[chatId] ?? []
        guard let index = chatBranches.firstIndex(where: { $0._id == branchId }) else { return }
        
        var branch = chatBranches[index]
        
        guard branch.state != state
        else { return }
        
        branch.state = state
        
        chatBranches[index] = branch
        branches[chatId] = chatBranches
    }
    
    func update(branch: Branch?, localState: ModelState?) {
        update(branchId: branch?._id, localState: localState)
    }
    
    func update(branchId: String?, localState: ModelState?) {
        guard let branchId else { return }
        branchesStates[branchId] = localState
    }
    
    // Model Updates
    
    func setBranches(response: [Branch]) {
        guard let chatId = response.first?.chat?._id else { return }
        branches[chatId] = response
    }
    
    func setBranch(name: String, branch: Branch) {
        guard
            let chatId = branch.chat?._id,
            let branchId = branch._id
        else { return }
        
        var chatBranches = branches[chatId] ?? []
        guard let branchIndex = chatBranches.firstIndex(where: { $0._id == branchId }) else { return }
        
        var branch = chatBranches[branchIndex]
        
        branch.name = name
        
        chatBranches[branchIndex] = branch
        branches[chatId] = chatBranches
    }
    
    func addBranch(_ branch: Branch) {
        guard
            let chatId = branch.chat?._id
        else { return }
        
        var chatBranches = branches[chatId] ?? []
        
        if chatBranches.isEmpty { chatBranches = [branch] }
        else { chatBranches.append(branch) }
        
        branches[chatId] = chatBranches
    }
    
    func remove(branch: Branch) {
        guard
            let chatId = branch.chat?._id,
            let branchId = branch._id
        else { return }
        
        var chatBranches = branches[chatId] ?? []
        guard let branchIndex = chatBranches.firstIndex(where: { $0._id == branchId }) else { return }
        
        chatBranches.remove(at: branchIndex)
        
        branches[chatId] = chatBranches
    }
    
    func updateBranch(branch: Branch) {
        guard
            let chatId = branch.chat?._id,
            let branchId = branch._id
        else { return }
        
        var chatBranches = branches[chatId] ?? []
        guard let branchIndex = chatBranches.firstIndex(where: { $0._id == branchId }) else { return }
        
        chatBranches[branchIndex] = branch
        
        branches[chatId] = chatBranches
    }
}

// MARK: - Message Modle Updates

extension ChatsState {
    
    func setMessages(messages: [Message], branch: Branch) {
        guard
            let branchId = branch._id
        else { return }
        
        self.messages[branchId] = messages
    }
    
    func addMessage(messages: [Message], branch: Branch) {
        guard
            let branchId = branch._id
        else { return }
        
        var branchMessages = self.messages[branchId] ?? []
        
        if branchMessages.isEmpty { branchMessages = messages }
        else { branchMessages.append(contentsOf: messages) }
        
        self.messages[branchId] = branchMessages
    }
    
    func removeMessage(message: Message) {
        guard
            let branchId = message.branch?._id,
            let messageId = message._id
        else { return }
        
        var branchMessages = self.messages[branchId] ?? []
        
        guard let messageIndex = branchMessages.firstIndex(where: { $0._id == messageId }) else { return }
        branchMessages.remove(at: messageIndex)
        
        self.messages[branchId] = branchMessages
    }
}

// MARK: - Draft

extension ChatsState {
    
    func draftFor(branchId: String?) -> MessageDraft? {
        guard let branchId else { return nil }
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
