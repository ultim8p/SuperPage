//
//  BranchViewControllerWrapper.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/13/23.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

struct BranchViewControllerWrapper: PlatformViewControlerRepresentable {
    
    @Binding var selectedBranchId: Branch.ID?
    
    @ObservedObject var branchEditState: BranchEditState
    
    @ObservedObject var chatsState: ChatsState
    
    var sendMessageHandler: ((_ message: String, _ model: AIModel, _ messageIds: [String]) -> Void)?
    
#if os(macOS)
    typealias NSViewControllerType = BranchViewController
    
    func makeNSViewController(context: Context) -> BranchViewController {
        return makeViewController()
    }
    
    func updateNSViewController(_ nsViewController: BranchViewController, context: Context) {
        updateViewController(nsViewController, context: context)
        
    }
#elseif os(iOS)
    typealias UIViewControllerType = BranchViewController
    
    func makeUIViewController(context: Context) -> BranchViewController {
        return makeViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        updateViewController(uiViewController, context: context)
    }
#endif
    
    func makeViewController() -> BranchViewController {
        let viewController = BranchViewController(
            selectedBranchId: selectedBranchId,
            chatsState: chatsState,
            branchEditState: branchEditState
        )
        viewController.sendMessageHandler = sendMessageHandler
        return viewController
    }
    
    func updateViewController(_ viewController: BranchViewController, context: Context) {
        viewController.selectedBranchId = selectedBranchId
        viewController.sendMessageHandler = sendMessageHandler
    }
}
