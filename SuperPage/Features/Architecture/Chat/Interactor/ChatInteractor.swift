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
    
    @Published var branches: [Branch] = []
    
    @Published var branch: Branch?
    
    @Published var messages: [Message] = []
    
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

extension ChatInteractor {
    func addBranch(response: Branch, to chat: Chat) {
        var chats = self.chats
        guard let chatIndex = chats.firstIndex(where: { $0._id == chat._id }) else { return }
        var updatingChat = chats[chatIndex]
        var branches = updatingChat.branches ?? []
        
        branches.append(response)
        
        updatingChat.branches = branches
        chats[chatIndex] = updatingChat
        self.chats = chats
    }
    
    func setBranches(response: [Branch], for chat: Chat) {
        var chats = self.chats
        guard let chatIndex = chats.firstIndex(where: { $0._id == chat._id }) else { return }
        var updatingChat = chats[chatIndex]
        updatingChat.branches = response
        chats[chatIndex] = updatingChat
        self.chats = chats
    }
    
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
    
    func remove(branch: Branch) {
        guard let chatIndex = chats.firstIndex(where: {$0.id == branch.chat?.id}) else { return }
        var chat = chats[chatIndex]
        
        var branches = chat.branches ?? []
        guard let branchIndex = branches.firstIndex(where: {$0.id == branch.id}) else { return }
        branches.remove(at: branchIndex)
        chat.branches = branches
        chats[chatIndex] = chat
    }
    
    func setBranch(name: String, branch: Branch) {
        guard let chatIndex = chats.firstIndex(where: {$0.id == branch.chat?.id}) else { return }
        var chat = chats[chatIndex]
        var branches = chat.branches ?? []
        guard let branchIndex = branches.firstIndex(where: {$0.id == branch.id}) else { return }
        
        var branch = branches[branchIndex]
        branch.name = name
        branches[branchIndex] = branch
        chat.branches = branches
        chats[chatIndex] = chat
    }
    
    func setChat(name: String, chat: Chat) {
        guard let chatIndex = chats.firstIndex(where: {$0.id == chat.id}) else { return }
        var chat = chats[chatIndex]
        chat.name = name
        chats[chatIndex] = chat
    }
}
