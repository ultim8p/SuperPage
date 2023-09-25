//
//  AttatchmentView.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/13/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

class AttatchmentView: NOViewController, NOPopoverable {
    
    var popover: NOPopoverViewController?
    
    var contentView: NOView!
    var topView: NOView!
    var headerView: NOView!
    
    var closeButton: PlatformButton!
    
    var placeholderTextView: NOTextView = NOTextView(frame: .zero, textContainer: nil)
    
    var textView: NOTextView = NOTextView(frame: .zero, textContainer: nil)
    
    var textHandler: ((_ text: String) -> Void)?
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    enum Constant {
        
        static let headerHeight = 50.0
        
        static let screenOffset = 15.0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        noSet(backgroundColor: SuperColor.popupBackground)
        setupView()
    }
    
    func setupView() {
        contentView = NOView()
        view.addSubview(contentView)
        contentView.onFull(to: view)
        contentView.noBackgroundColor = SuperColor.branchBackground
        
        headerView = NOView()
        contentView.addSubview(headerView)
        headerView.noBackgroundColor = SuperColor.toolBar
        headerView.onFullTop(to: contentView).height(Constant.headerHeight)
        
        setupCloseButton()
        
        setupTextView()
    }
    
    func set(text: String) {
        textView.noSetText(text: text)
    }
    
    // MARK: -  Setup
    
    func setupCloseButton() {
        closeButton = PlatformButton.noButton(image: .xmark)
        headerView.addSubview(closeButton)
        closeButton.onFullRight(to: headerView).width(Constant.headerHeight)
        closeButton.noTarget(self, action: #selector(closeButtonAction))
    }
    
    func setupTextView() {
        placeholderTextView.formatters = [TextFormat.placeholder(nil)]
        placeholderTextView.isEditable = false
        placeholderTextView.noSetText(text: """
        Add context for the AI to know about the conversation.
        For example:
            - Paste an essay you need help with.
            - Paste code you need help with.
            - Set an instruction like: Act as a laywer.
        """
        )
        
        contentView.addSubview(placeholderTextView)
        
        let textViewConstraintsView = textView.noEnableScroll()
        contentView.addSubview(textViewConstraintsView)
        
        
        
        textViewConstraintsView.onFullBottom(to: contentView, const: Constant.screenOffset).onBottom(to: headerView, const: Constant.screenOffset)
        textView.isEditable = true
        textView.noBecomeFirstResponder()
        textView.noTextViewDelegate = self
        
        
        placeholderTextView.onFullBottom(to: contentView, const: Constant.screenOffset).onBottom(to: headerView, const: Constant.screenOffset)
        
    }
    
    func onTextChange(handler: ((_ text: String) -> Void)?) {
        textHandler = handler
    }
    
    @objc func closeButtonAction() {
        popover?.noDismiss(animated: true)
    }
    
    func reloadPlaceholder() {
        placeholderTextView.isHidden = !textView.noText.isEmpty
    }
}

extension AttatchmentView: NOTextViewDelegate {
    
    func noTextViewDidChangeSize(_ textView: NOTextView) {
        reloadPlaceholder()
        textHandler?(textView.noText)
    }
    
    func noTextViewWillChangeText(_ textView: NOTextView) {
        
    }
}
