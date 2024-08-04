//
//  NavigationManager.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/10/24.
//

import SwiftUI

enum NavDestination: Hashable {
    case branch(_ id: Branch.ID)
}

@MainActor
final class NavigationManager: ObservableObject {
    
    @Published var selectedChatId: Chat.ID?
    
    @Published var selectedBranchId: Branch.ID?
    
    @Published var editingBranch: Branch?
    
    @Published var fromChatCreatingBranch: Chat?
    
    @Published var creatingChat: Chat?
    
    @Published var editingChat: Chat?
    
    @Published var sheetSettings: Bool = false
    
    @Published var sheetUpgrade: Bool = false
    
    @Published var sheetTokenStore: Bool = false
    
    @Published var expandedChatIds: Set<String> = []
    
    func toggleExpand(chatId: String) {
        if expandedChatIds.contains(chatId) {
            expandedChatIds.remove(chatId)
        } else {
            expandedChatIds.insert(chatId)
        }
    }
    
    func expand(chatId: String) {
        expandedChatIds.insert(chatId)
    }
    
    func openBranch(id: Branch.ID) {
        selectedBranchId = id
    }
    
    func openSettings() {
        sheetSettings = true
    }
}

extension NavigationManager {
    
    static var mock: NavigationManager {
        NavigationManager()
    }
}
