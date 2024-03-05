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
    
    @Binding var selectedBranchId: Branch.ID?
    
    // MARK: Actions
    
    @Binding var branchContextMenu: Branch
    
    @Binding var showBranchDeleteAlert: Bool
    
    // MARK: Environment
    
    @Environment(\.colorScheme) var colorScheme
    
    var editPressed: (() -> Void)?
    
    var selectionHandler: (() -> Void)?
    
    var body: some View {
        let isSelected = selectedBranchId == branch.id
        
            ZStack {
                HStack(spacing: 0) {
                    let hasError = branch.createMessageError != nil
                    let loading = branch.loadingState == .loading || branch.state == .creatingMessage
                    let name = branch.name ?? "No name"
                    
                    let imageName: String = hasError ?
                    SystemImage.exclamationMarkOctagon.rawValue :
                    branch.hasPromptText ?
                    SystemImage.docBadgeEllipsis.rawValue :
                    SystemImage.doc.rawValue
                    
                    let font: Font = .system(size: 14, weight: .regular)
                    let color: Color = .spDefaultText
                
                    ZStack {
                        if let emoji = branch.promptEmoj {
                            Text(emoji)
                                .font(font)
                        } else {
                            let iconColor: Color = hasError ? .red : .cyan
                            Image(systemName: imageName)
                                .foregroundColor(iconColor)
                                .font(font)
                        }
                    }
                    .frame(width: 22.0, height: 22.0)
                    
                    
                    Text(name)
                        .font(font)
                        .foregroundStyle(color)
                    Spacer()
                    if loading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(width: 20.0, height: 20.0)
                        #if os(macOS)
                            .scaleEffect(0.4)
                        #endif
                    }
                }
                .padding(.leading, 30)
                .padding(.trailing, 12)
        
        }
        .frame(maxWidth: .infinity)
        .frame(height: 22.0)
        .background(
            Group {
                if isSelected {
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(Color.spAction, lineWidth: 1) // Use strokeBorder for the border line
                        .padding(.leading, 8)
                        .padding(.trailing, 8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Color.clear
                }
            }
        )
        .contentShape(Rectangle())
        .onTapGesture {
            selectionHandler?()
        }
        .contextMenu {
            Button("Edit Page") {
                branchContextMenu = branch
                editPressed?()
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
            selectedBranchId: .constant(nil),
            branchContextMenu: .constant(Branch()),
            showBranchDeleteAlert: .constant(false)
        )
        .environmentObject(ChatInteractor.mock)
    }
}
