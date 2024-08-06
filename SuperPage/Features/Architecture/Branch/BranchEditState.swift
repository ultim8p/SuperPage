//
//  BranchEditState.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/25/24.
//

import Combine
import SwiftUI

@MainActor
final class BranchEditState: ObservableObject {
    
    @ObservedObject var chatsState: ChatsState
    
    @ObservedObject var navManager: NavigationManager
    
    // General
    let models = AIModel.allModels
    
    // Editing Entity
    
    @Published var selectedBranchRef: BranchReference? = nil
    
    // Edition State
    
    @Published var model: AIModel = AIModel.allModels.first!
    
    @Published var newMessage: String = ""
    
    @Published var selectedMessages: Set<String> = []
    
    // App Properties
    
    @Published var branch: Branch?
    
    @Published var draft: MessageDraft?
    
    @Published var messages: [Message] = []
    
    @Published var branchLocalState: ModelState?
    
    // Combine
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        chatsState = ChatsState.mock
        navManager = NavigationManager.mock
    }
    
    func inject(
        chatsState: ChatsState,
        navManager: NavigationManager
    ) {
        self.chatsState = chatsState
        self.navManager = navManager
        
        setupBindings()
    }
}

// MARK: - State

extension BranchEditState {
    
    private func setupBindings() {
        navManager.$selectedBranchRef.sink { [weak self] branchRef in
            self?.didChange(selectedBranch: branchRef)
        }.store(in: &cancellables)
        
        chatsState.$messages.sink { [weak self] messages in
            guard let branchId = self?.selectedBranchRef?._id else { return }
            
            let branchMessages = messages[branchId]
            self?.didChange(messages: branchMessages)
        }.store(in: &cancellables)
        
        
        chatsState.$branches.sink { [weak self] branches in
            guard 
                let chatId = self?.selectedBranchRef?.chat?._id,
                let branchId = self?.selectedBranchRef?._id,
                let branch = branches[chatId]?.first(where: { $0._id == branchId })
            else { return }
            
            self?.didChange(branch: branch)
        }.store(in: &cancellables)
        
        chatsState.$branchesStates.sink { [weak self] states in
            guard
                let branchId = self?.selectedBranchRef?._id,
                let state = states[branchId]
            else { return }
            
            self?.didChange(branchLocalState: state)
        }.store(in: &cancellables)
        
        chatsState.$drafts.sink { [weak self] drafts in
            guard
                let branchId = self?.selectedBranchRef?._id,
                let draft = drafts[branchId]
            else { return }
            
            self?.didChange(draft: draft)
        }.store(in: &cancellables)
    }
}

// MARK: - Update Selection State

private extension BranchEditState {
    
    private func didChange(selectedBranch ref: BranchReference?) {
        guard selectedBranchRef != ref else { return }
        
        // Save message draf & useful state of previous branch,
//        chatsState.save(draft: MessageDraft)
        
//        if !newMessage.isEmpty, let branch {
//            let draftMessage = Message.create(role: .user, text: newMessage)
//            let draft = MessageDraft(branch: branch, messages: [draftMessage])
//            chatsState.save(draft: draft)
//            print("GOT DRFT: backing up draft: \(newMessage)")
//        }
        
        selectedBranchRef = ref
        setupBranch()
    }
}

// MARK: - Update State

private extension BranchEditState {
    
    func didChange(messages: [Message]?) {
        self.messages = messages ?? []
    }
    
    func didChange(branchLocalState: ModelState?) {
        self.branchLocalState = branchLocalState
    }
    
    func didChange(branch: Branch?) {
        self.branch = branch
    }
    
    func didChange(draft: MessageDraft?) {
        self.draft = draft
    }
    
    func setupBranch() {
        newMessage = ""
        selectedMessages = []
        draft = nil
//        draft = chatsState.draftFor(branchId: selectedBranchRef?._id)
        branchLocalState = nil
        branch = chatsState.branchFor(branchRef: selectedBranchRef)
//        branchLocalState = chatsState.branchLocalStateFor(branchId: selectedBranchRef?._id)
        messages = []
//        messages = chatsState.messagesFor(branchId: selectedBranchRef?._id)
        
        guard let branch else { return }
        
        chatsState.getMessages(branch: branch)
        chatsState.getDraft(branch: branch)
    }
}

// MARK: - State Properties

private extension BranchEditState {
    
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
            let branchRef = selectedBranchRef,
            let branchId = branchRef._id
        else { return }
        
        let messages = chatsState.messagesFor(branchId: branchId)
        
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
            let branch = chatsState.branchFor(branchRef: selectedBranchRef)
        else { return }
        
//        let draftMessage = Message.create(role: .user, text: newMessage)
//        draft = MessageDraft(branch: branch, messages: [draftMessage])
        
        chatsState.postCreateMessage(
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
