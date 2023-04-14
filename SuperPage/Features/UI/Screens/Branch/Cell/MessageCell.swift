//
//  MessageCell.swift
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

protocol MessageCellDelegate: AnyObject {
    
    func messageCell(_ item: MessageCell, didPerform shortcut: KeyboardShortcut)
    
    func messageCellWillUpdateMessage(_ item: MessageCell)
    
    func messageCell(_ item: MessageCell, didUpdateMessage message: String)
}

class MessageCell: PlatformCollectionViewCell, NOTextViewDelegate, ClassNameProtocol {
    
//    static var horizontalPadding: CGFloat {
//        let isPhone = NODevice.isPhone
//        let isPortrait = NODevice.isPortrait
//        let isPad = NODevice.isPad
//        if isPhone && isPortrait {
//            return 16.0
//        } else if isPhone && !isPortrait {
//            return 80.0
//        } else if isPad && isPortrait {
//            return 100.0
//        }
//    }
    
    weak var delegate: MessageCellDelegate?
    
    var cardWidthConstraint: NSLayoutConstraint!
    
    let textView: NOTextView = NOTextView(frame: .zero, textContainer: nil)
    
    let placeholderTextView = NOTextView(frame: .zero, textContainer: nil)
    
    var cardView: NOView = NOView()
    
    var lineSeparator: NOView = NOView()
    
    var hasPlaceholder: Bool = false
    
    enum Constant {
        
        static let topSpace: CGFloat = 15.0
        
        static let bottomSpace: CGFloat = 15.0
    }
    
    #if os(macOS)
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardView()
        setupTextView()
    }
    
    #elseif os(iOS)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCardView()
        setupTextView()
    }
    #endif
    
    private func setupCardView() {
        noContentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.centerX(to: noContentView).top(to: noContentView).bottom(to: noContentView)
        cardWidthConstraint = cardView.widthAnchor.constraint(equalToConstant: NODevice.readableWidth(for: noContentView.bounds.size.width))
        cardWidthConstraint.isActive = true
        
        cardView.addSubview(lineSeparator)
        lineSeparator.noBackgroundColor = SuperColor.lineSeparator
        lineSeparator.onFullBottom(to: cardView).height(1.0)
    }
    
    private func setupTextView() {
        
        cardView.addSubview(placeholderTextView)
        
        textView.noTextViewDelegate = self
        cardView.addSubview(textView)
        textView.lead(to: cardView).trail(to: cardView).top(to: cardView, const: Constant.topSpace).bottom(to: cardView, const: -Constant.bottomSpace)
        
        textView.register(closure: {
            self.delegate?.messageCell(self, didPerform: .commandEnter)
        }, for: .commandEnter)
        
        placeholderTextView.formatters = [TextFormat.placeholder]
        placeholderTextView.onFull(to: textView)
        placeholderTextView.noSetText(text: "Type...")
        placeholderTextView.isEditable = false
    }
    
    func reloadConstraints(width: CGFloat) {
        cardWidthConstraint.constant = NODevice.readableWidth(for: width)
    }
    
    func configure(message: Message?, editable: Bool, width: CGFloat) {
//        let role = message?.role
//        let isAssistant = role == .assistant
//        let backgroundColor: PlatformColor = isAssistant ?
//            .clear :
//        SuperColor.userMessageBackground
//        cardView.noBackgroundColor = backgroundColor
        textView.noSetText(text: message?.text ?? "")
        textView.isEditable = editable
        reloadConstraints(width: width)
        lineSeparator.isHidden = false
        hasPlaceholder = false
        reloadPlaceholder()
    }
    
    func configure(text: String, editable: Bool, width: CGFloat) {
//        cardView.noBackgroundColor = SuperColor.userMessageBackground
        textView.noSetText(text: text)
        textView.isEditable = editable
        reloadConstraints(width: width)
        lineSeparator.isHidden = true
        hasPlaceholder = true
        reloadPlaceholder()
    }
    
    func reloadPlaceholder() {
        let text = textView.noText
        placeholderTextView.isHidden = (hasPlaceholder && !text.isEmpty) || !hasPlaceholder
    }
}

extension MessageCell {
    func noTextViewWillChangeText(_ textView: NOTextView) {
        delegate?.messageCellWillUpdateMessage(self)
    }
    
    func noTextViewDidChangeSize(_ textView: NOTextView) {
        reloadPlaceholder()
        delegate?.messageCell(self, didUpdateMessage: textView.noText)
    }
}
