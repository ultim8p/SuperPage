//
//  NOTextViewCell.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/8/24.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

protocol NOTextViewCellDelegate: AnyObject {
    
    func noTextViewCell(_ cell: NOTextViewCell, didPerform shortcut: KeyboardShortcut)
    
    func noTextViewCellWillUpdateMessage(_ cell: NOTextViewCell)
    
    func noTextViewCell(_ cell: NOTextViewCell, didUpdateMessage message: String)
}

class NOTextViewCell: PCollectionViewCell, ClassNameProtocol {
    
    weak var delegate: NOTextViewCellDelegate?
    
    let textView = NOTextView(frame: .zero, textContainer: nil)
    let placeholderTextView = NOTextView(frame: .zero, textContainer: nil)
    
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
        noContentView.addSubview(placeholderTextView)
        placeholderTextView.formatters = [TextFormat.placeholder(nil)]
        placeholderTextView
            .lead(to: noContentView)
            .trail(to: noContentView)
            .bottom(to: noContentView)
            .top(to: noContentView)
        placeholderTextView.isEditable = false
        placeholderTextView.isSelectable = false
        
        noContentView.addSubview(textView)
        textView.noTextViewDelegate = self
        textView.isEditable = true
        textView.isSelectable = true
        textView
            .lead(to: noContentView)
            .trail(to: noContentView)
            .bottom(to: noContentView)
            .top(to: noContentView)
        
        textView.register(closure: {
            self.delegate?.noTextViewCell(self, didPerform: .commandEnter)
        }, for: .commandEnter)
    }
    
    func reloadPlaceholder() {
        placeholderTextView.isHidden = !textView.noText.isEmpty
    }
}

extension NOTextViewCell: NOTextViewDelegate {
    
    func noTextViewWillChangeText(_ textView: NOTextView) {
        delegate?.noTextViewCellWillUpdateMessage(self)
        reloadPlaceholder()
    }
    
    func noTextViewDidChangeSize(_ textView: NOTextView) {
        delegate?.noTextViewCell(self, didUpdateMessage: textView.noText)
    }
}

extension NOTextViewCell {
    
    func configure(placeHolder: String?) {
        placeholderTextView.noSetText(text: placeHolder ?? "")
    }
    
    func configure(text: String?) {
        textView.noSetText(text: text ?? "")
        reloadPlaceholder()
    }
}
