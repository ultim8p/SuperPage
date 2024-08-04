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
    
    func messageCellDidTap(_ item: MessageCell)
}

class MessageCell: PCollectionViewCell, NOTextViewDelegate, ClassNameProtocol {
    
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
    
#if os(macOS)
    
#endif
    
    weak var delegate: MessageCellDelegate?
    
    var cardWidthConstraint: NSLayoutConstraint!
    
    let textView: NOTextView = NOTextView(frame: .zero, textContainer: nil)
    
    let placeholderTextView = NOTextView(frame: .zero, textContainer: nil)
    
    var cardView: NOView = NOView()
    
    var selectedBar: NOView = NOView()
    
    var lineSeparator: NOView = NOView()
    
    var leftView: NOView = NOView()
    
    var ownerBubble = ChatOwnerBubble()
    
    var hasPlaceholder: Bool = false
    
    var isTapped: Bool = false
    
    var isInput: Bool = false
    
    var isHovered: Bool = false
    
    enum Constant {
        static let topSpace: CGFloat = 22.0
        static let bottomSpace: CGFloat = 22.0
        static let barHoverWidth: CGFloat = 10.0
        static let barWidth: CGFloat = 4.0
    }
    
    #if os(macOS)
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    #elseif os(iOS)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    #endif
    
    func setupView() {
        noContentView.addSubview(selectedBar)
        noContentView.addSubview(leftView)
        noContentView.addSubview(cardView)
        cardView.addSubview(placeholderTextView)
        cardView.addSubview(ownerBubble)
        cardView.addSubview(textView)
        
        setupBackgroundViews()
        setupCardView()
        setupTextView()
        setupSelectedBar()
    }
    
    private func setupSelectedBar() {
        selectedBar
            .onLeft(to: textView, const: -2.0)
            .top(to: textView)
            .bottom(to: textView)
            .width(4.0)
        selectedBar.noSet(radius: 2.0)
        selectedBar.noBackgroundColor = SuperColor.icon
        selectedBar.isHidden = true
    }
    
    private func setupBackgroundViews() {
        leftView.lead(to: noContentView).top(to: noContentView).bottom(to: noContentView).onLeft(to: cardView)
        
        leftView.onTap { [weak self] in
            guard let self, !isInput else { return }
            self.isTapped = !isTapped
            self.reloadSelectedBarState()
            self.delegate?.messageCellDidTap(self)
        }
        
        leftView.onHover { [weak self] mouseOn in
            guard let self, !isInput else { return }
            isHovered = mouseOn
            let barWidth = mouseOn ? Constant.barHoverWidth : Constant.barWidth
            selectedBar.noSet(radius: barWidth * 0.5)
            selectedBar.width(barWidth)
//            self.textView.backgroundColor = mouseOn ?
//                .black.withAlphaComponent(0.1) :
//                .clear
            reloadSelectedBarState()
        }
    }
    
    private func setupCardView() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.centerX(to: noContentView).top(to: noContentView).bottom(to: noContentView)
        cardWidthConstraint = cardView.widthAnchor.constraint(equalToConstant: NODevice.readableWidth(for: noContentView.bounds.size.width))
        cardWidthConstraint.isActive = true
        
        cardView.addSubview(lineSeparator)
        lineSeparator.noBackgroundColor = SuperColor.lineSeparator
        lineSeparator.onFullTop(to: cardView).height(1.0)
    }
    
    private func setupTextView() {
        textView.noTextViewDelegate = self
        textView.lead(to: cardView).trail(to: cardView)
            .top(to: cardView, const: Constant.topSpace)
            .bottom(to: cardView, const: Constant.bottomSpace)
        
        textView.register(closure: {
            self.delegate?.messageCell(self, didPerform: .commandEnter)
        }, for: .commandEnter)
        
        ownerBubble.top(to: cardView, const: 1.0).lead(to: cardView, const: 0.0)
        placeholderTextView.formatters = [TextFormat.placeholder(nil)]
        placeholderTextView.onFull(to: textView)
        placeholderTextView.noSetText(text: "Type...\n\nShortcuts:\n · [⌘ ENTER] To to submit.\n · [⌘ M] To change AI model.\n · [⌘ E] to edit the Page’s properties.")
        placeholderTextView.isEditable = false
        placeholderTextView.isSelectable = false
    }
    
    func reloadConstraints(width: CGFloat) {
        cardWidthConstraint.constant = NODevice.readableWidth(for: width)
    }
    
    func reloadSelectedBarState() {
        selectedBar.isHidden = !(isTapped || isHovered)
        selectedBar.noBackgroundColor = isTapped ? SuperColor.icon : SuperColor.icon.withAlphaComponent(0.4)
    }
    
    func configure(message: Message?, editable: Bool, width: CGFloat, isSelected: Bool) {
//        let role = message?.role
//        let isAssistant = role == .assistant
//        let backgroundColor: PlatformColor = isAssistant ?
//            .clear :
//        SuperColor.userMessageBackground
//        cardView.noBackgroundColor = backgroundColor
        isHovered = false
        isInput = false
        isTapped = isSelected
        selectedBar.isHidden = !isTapped
        textView.noSetText(text: message?.fullTextValue() ?? "")
        textView.isEditable = false
        textView.isSelectable = true
        reloadConstraints(width: width)
        lineSeparator.isHidden = true
        hasPlaceholder = false
        ownerBubble.isHidden = false
        reloadPlaceholder()
        ownerBubble.configure(message)
        reloadSelectedBarState()
    }
    
    func configure(text: String, editable: Bool, width: CGFloat, showSeparator: Bool) {
//        cardView.noBackgroundColor = SuperColor.userMessageBackground
        isInput = true
        isTapped = false
        hasPlaceholder = true
        ownerBubble.isHidden = true
        selectedBar.isHidden = true
        textView.noSetText(text: text)
        textView.isEditable = editable
        textView.isSelectable = true
        reloadConstraints(width: width)
        lineSeparator.isHidden = !showSeparator
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
