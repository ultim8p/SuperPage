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
import NoUI

class SendMessageToolBar: NOView {
    
    var sendHandler: (() -> Void)?
    
    var messagesSelectedHandler: (() -> Void)?
    
    var modelHandler: (() -> Void)?
    
    let contentView: NOView = NOView()
    
    var spinner: NOSpinner!
    
    var widthConstraint: NSLayoutConstraint!
    
    let sendButton: PlatformButton = PlatformButton.noButton(image: .paperplaneFill)
    
    let messagesSelectedButton: PlatformButton = PlatformButton.noButton(image: .square)
    
    let modelButton: PlatformButton = PlatformButton()
    
    let messagesCountLabel = NOTextView(frame: .zero, textContainer: nil)
    
    var messagesCount: Int = 0
    var selectedMessagesCount: Int = 0
    
    var model: AIModel?
    
    enum Constant {
        static let height: CGFloat = 50.0
        static let contentHeight: CGFloat = 50.0
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
        contentView.lead(to: self).bottom(to: self).trail(to: self).height(Constant.contentHeight)
        
        contentView.addSubview(sendButton)
        sendButton.safeTrail(to: contentView, const: -Constant.buttonSpacing)
            .top(to: contentView).bottom(to: contentView).width(Constant.contentHeight)
        sendButton.noTarget(self, action: #selector(sendButtonTapped))
        
        contentView.addSubview(modelButton)
        modelButton.onLeft(to: sendButton, const: 0.0)
            .top(to: contentView).bottom(to: contentView)
        modelButton.noTarget(self, action: #selector(modelButtonAction))
        
        spinner = NOSpinner.noSpinner(inView: contentView, centerTo: sendButton)
        
        contentView.addSubview(messagesSelectedButton)
        messagesSelectedButton
            .safeLead(to: contentView, const: 0.0)
            .top(to: contentView).bottom(to: contentView).width(Constant.contentHeight)
        messagesSelectedButton.noTarget(self, action: #selector(messagesSelectedButtonAction))
        
        contentView.addSubview(messagesCountLabel)
        messagesCountLabel.isEditable = false
        messagesCountLabel.isSelectable = false
        messagesCountLabel.noSetAlignment(.left)
        messagesCountLabel.formatters = [TextFormat.action(14)]
        messagesCountLabel.onRight(to: messagesSelectedButton, const: -12.0).centerY(to: contentView)
    }
    
    static func setup(in view: PlatformView) -> SendMessageToolBar {
        let toolBar = SendMessageToolBar()
        view.addSubview(toolBar)
        
        toolBar.contentView.noBackgroundColor = SuperColor.toolBar
        toolBar.onFullBottom(to: view).height(Constant.height)
        
        return toolBar
    }
    
    func updateMessageSelection(count: Int, selectedCount: Int) {
        self.messagesCount = count
        self.selectedMessagesCount = selectedCount
        reloadProgressState()
    }
    
    func reloadProgressState() {
        let msgsSize = messagesCountLabel.targetTextSize(targetWidth: bounds.size.width)
//        messagesCountLabel.noSetText(text: "\(selectedMessagesCount) messages")
        messagesCountLabel.height(msgsSize.height).width(msgsSize.width)
        let hasSelectedMessages = selectedMessagesCount > 0
        let hasMessages = messagesCount > 0
        messagesCountLabel.isHidden = !hasSelectedMessages
        messagesSelectedButton.noSetImage(hasSelectedMessages ? .checkmarkSquare : .square)
        messagesSelectedButton.isHidden = !hasMessages
    }
    
    func onSend(handler: (() -> Void)?) {
        self.sendHandler = handler
    }
    
    func messagesSelected(handler: (() -> Void)?) {
        self.messagesSelectedHandler = handler
    }
        
    func onModel(handler: (() -> Void)?) {
        self.modelHandler = handler
    }
    
    @objc private func sendButtonTapped() {
        sendHandler?()
    }
    
    @objc private func messagesSelectedButtonAction() {
        messagesSelectedHandler?()
    }
    
    @objc private func modelButtonAction() {
        modelHandler?()
    }
    
    func reloadConstraints() {
        
    }
    
    func set(aiModel: AIModel) {
        model = aiModel
        reloadProgressState()
        modelButton.no(setTitle: "🤖 \(aiModel.displayName ?? "")")
    }
}
