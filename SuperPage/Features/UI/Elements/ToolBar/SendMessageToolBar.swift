//
//  SendMessageToolBar.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/12/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

class SendMessageToolBar: NOView {
    
    var sendHandler: (() -> Void)?
    
    var chatModeHandler: (() -> Void)?
    
    var systemRoleHandler: (() -> Void)?
    
    var modelHandler: (() -> Void)?
    
    let contentView: NOView = NOView()
    
    var spinner: NOSpinner!
    
    var widthConstraint: NSLayoutConstraint!
    
    let sendButton: PlatformButton = PlatformButton.noButton(image: .paperplaneFill)
    
    let chatModeButton: PlatformButton = PlatformButton.noButton(image: .square)
    
    let systemRoleButton: PlatformButton = PlatformButton.noButton(image: .paperclip)
    
    let modelButton: PlatformButton = PlatformButton()
    
    enum Constant {
        static let height: CGFloat = 50.0
        static let buttonSpacing: CGFloat = 16.0
    }
    
    override init() {
        super.init()
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(loading: Bool) {
        spinner.isHidden = !loading
        sendButton.isHidden = loading
    }
    
    func setupView() {
        addSubview(contentView)
        contentView.onFull(to: self)
        
        contentView.addSubview(sendButton)
        sendButton.safeTrail(to: contentView, const: -Constant.buttonSpacing)
            .top(to: contentView).bottom(to: contentView).width(Constant.height)
        sendButton.noTarget(self, action: #selector(sendButtonTapped))
        
        spinner = NOSpinner.noSpinner(inView: contentView, centerTo: sendButton)
        
        contentView.addSubview(chatModeButton)
        chatModeButton.safeLead(to: contentView, const: Constant.buttonSpacing)
            .top(to: contentView).bottom(to: contentView).width(Constant.height)
        chatModeButton.noTarget(self, action: #selector(chatModeButtonAction))
        
        contentView.addSubview(systemRoleButton)
        systemRoleButton.onRight(to: chatModeButton, const: 0.0)
            .top(to: contentView).bottom(to: contentView).width(Constant.height)
        systemRoleButton.noTarget(self, action: #selector(systemRoleAction))
        
        contentView.addSubview(modelButton)
        modelButton.onRight(to: systemRoleButton, const: 0.0)
            .top(to: contentView).bottom(to: contentView)
        modelButton.noTarget(self, action: #selector(modelButtonAction))
    }
    
    static func setup(in view: PlatformView) -> SendMessageToolBar {
        let toolBar = SendMessageToolBar()
        view.addSubview(toolBar)
        
        toolBar.contentView.noBackgroundColor = SuperColor.toolBar
        toolBar.onFullBottom(to: view).height(Constant.height)
        
        return toolBar
    }
    
    func onSend(handler: (() -> Void)?) {
        self.sendHandler = handler
    }
    
    func onChatMode(handler: (() -> Void)?) {
        self.chatModeHandler = handler
    }
    
    func onSystemRole(handler: (() -> Void)?) {
        self.systemRoleHandler = handler
    }
        
    func onModel(handler: (() -> Void)?) {
        self.modelHandler = handler
    }
    
    @objc private func sendButtonTapped() {
        sendHandler?()
    }
    
    @objc private func chatModeButtonAction() {
        chatModeHandler?()
    }
    
    @objc private func systemRoleAction() {
        systemRoleHandler?()
    }
    
    @objc private func modelButtonAction() {
        modelHandler?()
    }
    
    func reloadConstraints() {
        
    }
    
    func set(systemRole: Bool) {
        systemRoleButton.noSetImage(systemRole ? .paperclipBadgeEllipsis : .paperclip)
    }
    
    func set(chatMode: Bool) {
        chatModeButton.noSetImage(chatMode ? .checkmarkSquare : .square)
    }
    
    func set(aiModel: AIModel) {
        modelButton.no(setTitle: "🤖 \(aiModel.botName)")
    }
    
    func systemRoleFrame() -> PlatformRect {
        return PlatformRect(
            x: contentView.frame.origin.x + systemRoleButton.frame.origin.x,
            y: 0.0,
            width: systemRoleButton.bounds.size.width,
            height: systemRoleButton.bounds.size.height)
    }
}
