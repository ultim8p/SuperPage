//
//  NOTextView.swift
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

protocol NOTextViewDelegate: AnyObject {
    
    func noTextViewDidChangeSize(_ textView: NOTextView)
    
    func noTextViewWillChangeText(_ textView: NOTextView)
}

class NOTextView: PlatformTextView, TextFormatting {
    
    // MARK: KeyboardShortcuts
    
    private var documentScrollView: PlatformScrollView!
    
    private var shortcutClosureMap: [KeyboardShortcut: (() -> Void)] = [:]
    
    func register(closure: (() -> Void)?, for shortcut: KeyboardShortcut) {
        shortcutClosureMap[shortcut] = closure
    }
    
    var macScrollEnabled: Bool = false
    
    // MARK: TextFormatting
    
    var markupRanges: [String : [NSRange]] = [:]
    
    var formatters: [TextFormatter] = [
        TextFormat.defaultText,
        TextFormat.defaultCode,
        TextFormat.codeKeywords,
        TextFormat.codeTypes,
        TextFormat.codeVariableNames,
        TextFormat.codeStrings,
        TextFormat.codeComments,
    ]
    
    weak var noTextViewDelegate: NOTextViewDelegate?
    
    override func paste(_ sender: Any?) {
        pasteWithoutFormat(sender)
    }
    
    func pasteWithoutFormat(_ sender: Any?) {
    #if os(macOS)
        guard let pasteboard = NSPasteboard.general.string(forType: .string)
        else { return }
        insertText(pasteboard, replacementRange: selectedRange())
    #elseif os(iOS)
        guard let pasteboard = UIPasteboard.general.string else { return }
                insertText(pasteboard)
    #endif
        didChangeTextViewText()
    }
    
#if os(macOS)
    override func didChangeText() {
        super.didChangeText()
        willChangeTextViewText()
        didChangeTextViewText()
    }
    
    override func keyDown(with event: NSEvent) {
        for (shortcut, closure) in shortcutClosureMap {
            if event.modifierFlags.contains(shortcut.flags) &&
                shortcut.keyCodes.contains(Int(event.keyCode)) {
                closure()
                return
            }
        }
        super.keyDown(with: event)
    }
#endif
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        let textStorage = NSTextStorage()
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer()
        textContainer.widthTracksTextView = true
        textContainer.heightTracksTextView = true
        layoutManager.addTextContainer(textContainer)
        super.init(frame: frame, textContainer: textContainer)
        
        initialSetup()
    }
    
    func initialSetup() {
        translatesAutoresizingMaskIntoConstraints = false
        isSelectable = true
        delegate = self
    #if os(macOS)
        wantsLayer = false
        layer?.backgroundColor = .clear
        backgroundColor = .clear
    #elseif os(iOS)
        backgroundColor = .clear
        textContainer.lineFragmentPadding = 0
        contentInset = .zero
        textContainerInset = UIEdgeInsets.zero
        isScrollEnabled = false
    #endif
    }
    
    func noEnableScroll() -> PlatformView {
#if os(macOS)
        macScrollEnabled = true
        
        translatesAutoresizingMaskIntoConstraints = true
        autoresizingMask = [.width]
        isHorizontallyResizable = false
        isVerticallyResizable = true
        
//        textContainer?.widthTracksTextView = true
//        textContainer?.heightTracksTextView = true
        
        
//        textContainer?.containerSize = PlatformSize(width: 200.0, height: 200.0)
        documentScrollView = PlatformScrollView(frame: .zero)
        documentScrollView.hasVerticalScroller = true
        documentScrollView.hasHorizontalScroller = false
        documentScrollView.borderType = .noBorder
        documentScrollView.drawsBackground = false
        documentScrollView.documentView = self
        
//        documentScrollView.addSubview(self)
//        self.onFull(to: documentScrollView)
        return documentScrollView
#elseif os(iOS)
        alwaysBounceVertical = true
        isScrollEnabled = true
        return self
#endif
    }
    
    func noSetText(text: String) {
    #if os(macOS)
        self.string = text
    #elseif os(iOS)
        self.text = text
    #endif
        didChangeTextViewText()
    }
    
    
    var targetTextSize: PlatformSize {
    #if os(macOS)
        guard let layoutManager = layoutManager, let textContainer = textContainer else {
            return .zero
        }

        layoutManager.textContainerChangedGeometry(textContainer)
        layoutManager.ensureLayout(for: textContainer)
        
        let usedRect = layoutManager.usedRect(for: textContainer)
        return usedRect.size
    #elseif os(iOS)
        let contentSize = sizeThatFits(CGSize(width: bounds.width, height: .greatestFiniteMagnitude))
        return CGSize(width: bounds.width, height: contentSize.height)
    #endif
    }
    
    func didChangeTextViewText() {
        refreshFormat()
        
        noTextViewDelegate?.noTextViewDidChangeSize(self)
    }
    
    func willChangeTextViewText() {
        noTextViewDelegate?.noTextViewWillChangeText(self)
    }
}

// MARK: - TextViewDelegate

extension NOTextView: PlatformTextViewDelegate {
    
    #if os(macOS)
    
    #elseif os(iOS)
    func textViewDidChange(_ textView: UITextView) {
        didChangeTextViewText()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        willChangeTextViewText()
        return true
    }
    #endif
}
