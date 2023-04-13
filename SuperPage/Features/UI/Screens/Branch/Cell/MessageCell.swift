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
    
    let textView: NOTextView = {
        let tv = NOTextView(frame: .zero, textContainer: nil)
        return tv
    }()
    
    var cardView: NOView = NOView()
    
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
        NSLayoutConstraint.activate([
            cardView.centerXAnchor.constraint(equalTo: noContentView.centerXAnchor),
            cardView.topAnchor.constraint(equalTo: noContentView.topAnchor, constant: 0),
            cardView.bottomAnchor.constraint(equalTo: noContentView.bottomAnchor, constant: 0),
        ])
        cardWidthConstraint = cardView.widthAnchor.constraint(equalToConstant: NODevice.readableWidth(for: noContentView.bounds.size.width))
        cardWidthConstraint.isActive = true
    }
    
    private func setupTextView() {
        textView.noTextViewDelegate = self
        cardView.addSubview(textView)
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 0),
            textView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 0),
            textView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 0),
            textView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 0)
        ])
        
        textView.register(closure: {
            self.delegate?.messageCell(self, didPerform: .commandEnter)
        }, for: .commandEnter)
    }
    
    func noTextViewWillChangeText(_ textView: NOTextView) {
        delegate?.messageCellWillUpdateMessage(self)
    }
    
    func noTextViewDidChangeSize(_ textView: NOTextView) {
        delegate?.messageCell(self, didUpdateMessage: textView.noText)
    }
    
    func reloadConstraints(width: CGFloat) {
        cardWidthConstraint.constant = NODevice.readableWidth(for: width)
    }
    
    func configure(message: Message?, editable: Bool, width: CGFloat) {
        let role = message?.role
        let isAssistant = role == .assistant
        let backgroundColor: PlatformColor = isAssistant ?
            .clear :
        PlatformColor(named: "userMessageBackground")!
        cardView.noBackgroundColor = backgroundColor
        textView.noSetText(text: message?.text ?? "")
        textView.isEditable = editable
        reloadConstraints(width: width)
    }
    
    func configure(text: String, editable: Bool, width: CGFloat) {
        cardView.noBackgroundColor = PlatformColor(named: "userMessageBackground")!
        textView.noSetText(text: text)
        textView.isEditable = editable
        reloadConstraints(width: width)
    }
}
