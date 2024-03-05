//
//  BranchEditState.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/25/24.
//

import Combine
import SwiftUI

final class BranchEditState: ObservableObject {
    
    @ObservedObject var chatInt: ChatInteractor
    
    @ObservedObject var navManager: NavigationManager
    
    // General
    let models = AIModel.allModels
    
    // Editing Entity
    
    var selectedBranchId: Branch.ID? = nil
    
    // Edition State
    
    @Published var model: AIModel = AIModel.allModels.first!
    
    @Published var messageDraft: MessageDraft?
    
    @Published var newMessage: String = ""
    
    @Published var selectedMessages: Set<String> = []
    
    // Combine
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        chatInt = ChatInteractor.mock
        navManager = NavigationManager.mock
    }
    
    func inject(chatInt: ChatInteractor, navManager: NavigationManager) {
        self.chatInt = chatInt
        self.navManager = navManager
        
        setupBindings()
    }
}

// MARK: - State

extension BranchEditState {
    
    private func setupBindings() {
        navManager.$selectedBranchId
            .sink { [weak self] selectedBranchId in
                self?.didChange(selectedBranch: selectedBranchId)
            }
            .store(in: &cancellables)
    }
        
    private func didChange(selectedBranch branchId: Branch.ID?) {
        guard selectedBranchId != branchId else {
            // Save message draf & useful state of previous branch,
            return
        }
        selectedBranchId = branchId
        // Update your branch edit state accordingly
        resetBranch()
    }
    
    func resetBranch() {
        messageDraft = nil
        newMessage = ""
        selectedMessages = []
    }
}

// MARK: - Actions

extension BranchEditState {
    
    func modelButtonAction() {
        if let currentIndex = models.firstIndex(where: { $0.name == model.name }) {
            if currentIndex == models.count - 1 {
                model = models[0]
            } else {
                model = models[currentIndex + 1]
            }
        }
    }
    
    func didTapSelectedMessages() {
        if selectedMessages.isEmpty {
            selectDefaultMessages()
        } else {
            selectedMessages = []
        }
    }
    
    func selectDefaultMessages() {
        guard
            let branchId = selectedBranchId,
            let messages = chatInt.branch(id: branchId)?.messages
        else { return }
        
        let maxMessages = 3
        var messageIds: Set<String> = []
        for message in messages.reversed() {
            guard messageIds.count <= maxMessages, let id = message._id else { break }
            messageIds.insert(id)
        }
        
        selectedMessages = messageIds
    }
    
    func toggleMessageSelection(id: String?) {
        guard let id else { return }
        
        if selectedMessages.contains(id) {
            selectedMessages.remove(id)
        } else {
            selectedMessages.insert(id)
        }
    }
}
 
// MARK: - API

extension BranchEditState {
    
    func sendMessage() {
        guard
            !newMessage.isEmpty,
            let branchId = selectedBranchId,
            let branch = chatInt.branch(id: branchId)
        else { return }
        
        let draftMessage = Message.create(role: .user, text: newMessage)
        messageDraft = MessageDraft(branch: branch, messages: [draftMessage])
        
        chatInt.postCreateMessage(
            text: newMessage,
            model: model,
            branch: branch,
            messageIds: Array(selectedMessages)
        )
        
        newMessage = ""
    }
}

extension BranchEditState {
    
    static var mock: BranchEditState {
            BranchEditState()
    }
}
