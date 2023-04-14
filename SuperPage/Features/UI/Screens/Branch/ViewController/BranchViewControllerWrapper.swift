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
    
    @Binding var messages: [Message]
    
    @Binding var systemRole: String
    
    @Binding var chatMode: Bool
    
    var sendMessageHandler: ((_ message: String) -> Void)?
    
    var saveContextHandler: ((_ systemRole: String, _ chatMode: Bool) -> Void)?
    
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
            messages: messages, localMessages: messages,
            chatMode: chatMode, localChatMode: chatMode,
            systemRole: systemRole, localSystemRole: systemRole)
        viewController.sendMessageHandler = sendMessageHandler
        viewController.saveContextHandler = saveContextHandler
        return viewController
    }
    
    func updateViewController(_ viewController: BranchViewController, context: Context) {
        viewController.messages = messages
        viewController.localMessages = _messages.wrappedValue
        viewController.sendMessageHandler = sendMessageHandler
        viewController.saveContextHandler = saveContextHandler
        viewController.chatMode = chatMode
        viewController.localChatMode = _chatMode.wrappedValue
        viewController.systemRole = systemRole
        viewController.localSystemRole = _systemRole.wrappedValue
    }
}
