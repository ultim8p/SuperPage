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
    
    @Binding var showBranchDeleteAlert: Bool
    
    // MARK: Environment
    
    @Environment(\.colorScheme) var colorScheme
    
    var editPressed: (() -> Void)?
    
    var body: some View {
        HStack {
            let hasError = branch.createMessageError != nil
            let loading = branch.loadingState == .loading || branch.state == .creatingMessage
            let name = branch.name ?? "No name"
            
            let imageName: String = hasError ?
            SystemImage.exclamationMarkOctagon.rawValue :
            branch.hasPromptText ?
            SystemImage.docBadgeEllipsis.rawValue :
            SystemImage.doc.rawValue
            
            let font: Font = .body
            let darkMode = colorScheme == .dark
            let color: Color = darkMode ?
            Color(CGColor(gray: 0.7, alpha: 1)) :
            Color(red: 0.0, green: 0.0, blue: 0.0)
        
            if let emoji = branch.promptEmoj {
                Text(emoji)
                    .font(.body)
                    .padding(.leading, -3.0)
                    .padding(.trailing, -2.0)
            } else {
                let iconColor: Color = hasError ? .red : .cyan
                Image(systemName: imageName)
                    .foregroundColor(iconColor)
                    .font(font)
            }
            
            Text(name)
                .font(font)
                .foregroundColor(color)
            Spacer()
            if loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(width: 20.0, height: 20.0)
                #if os(macOS)
                    .scaleEffect(0.5)
                #endif
            }
        }
        .padding(.leading, 24)
        .contextMenu {
            Button("Edit") {
                branchContextMenu = branch
//                showEditBranch = true
                editPressed?()
            }
            Button("Delete") {
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
            showBranchDeleteAlert: .constant(false))
        .environmentObject(ChatInteractor.mock)
    }
}
