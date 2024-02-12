//
//  NavigationManager.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/10/24.
//

import SwiftUI

class NavigationManager: ObservableObject {
    
    @Published var selectedChatId: Chat.ID?
    
    @Published var selectedBranchId: Branch.ID?
    
    @Published var editingBranch: Branch?
    
    @Published var fromChatCreatingBranch: Chat?
    
}
