//
//  BranchRow.swift
//  SuperPage
//
//  Created by Guerson Perez on 8/7/23.
//

import Foundation
import SwiftUI

struct BranchRow: View {
    
    @EnvironmentObject var chatInt: ChatInteractor
    
    @Binding var branch: Branch
    
    // MARK: Actions
    
    @Binding var branchContextMenu: Branch
    
    @Binding var showEditBranch: Bool
    
    @Binding var showBranchDeleteAlert: Bool
    
    // MARK: LocalVariables
    
    @State var systemRole: String = ""
    
    var body: some View {
        HStack {
            FileRow(
                name: branch.name ?? "No name",
                folder: false,
                isExpanded: false,
                loading: branch.loadingState == .loading || branch.state == .creatingMessage,
                hasError: branch.createMessageError != nil
            )
        }
        .contextMenu {
            Button("Rename Page") {
                branchContextMenu = branch
                showEditBranch = true
            }
            Button("Delete Page") {
                branchContextMenu = branch
                showBranchDeleteAlert = true
            }
        }
        .alert(
            "After hitting Delete this Page will be permanently deleted.",
            isPresented: $showBranchDeleteAlert)
        {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                chatInt.deleteBranch(branch: branchContextMenu)
            }
        }
    }
}

struct BranchRow_Previews: PreviewProvider {

    @State var branchName: String = ""

    static var previews: some View {
        BranchRow(
            branch: .constant(Branch(name: "Test Page")),
            branchContextMenu: .constant(Branch()),
            showEditBranch: .constant(false),
            showBranchDeleteAlert: .constant(false))
        .environmentObject(ChatInteractor.mock)
    }
}
