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

class NOTextView: PTextView, TextFormatting {
    
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
        TextFormat.defaultText(nil),
        TextFormat.defaultCode(nil),
        TextFormat.codeKeywords(nil),
        TextFormat.codeTypes(nil),
        TextFormat.codeVariableNames(nil),
        TextFormat.codeStrings(nil),
        TextFormat.codeComments(nil),
        TextFormat.mdH1(nil),
        TextFormat.mdH2(nil),
        TextFormat.mdH3(nil),
        TextFormat.mdH4(nil),
        TextFormat.mdBold(nil),
        TextFormat.mdBold1(nil),
//        TextFormat.mdCode(nil)
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
    
    // MARK: - MouseActions
    
    var trackingArea: NSTrackingArea?
    
    typealias HoverHandler = ((_ mouseOn: Bool) -> Void)
    typealias TapHandler = (() -> Void)
    
    var hoverHandler: HoverHandler?
    var tapHandler: TapHandler?
    
    func onHover(_ handler: HoverHandler?) {
        hoverHandler = handler
    }
    
    func onTap(_ handler: TapHandler?) {
        tapHandler = handler
    }
    
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if let trackingArea = self.trackingArea {
            self.removeTrackingArea(trackingArea)
        }
        
        trackingArea = NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: self,
            userInfo: nil
        )
        
        if let trackingArea = trackingArea {
            self.addTrackingArea(trackingArea)
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        hoverHandler?(true)
    }
    
    override func mouseExited(with event: NSEvent) {
        hoverHandler?(false)
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        tapHandler?()
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
        textContainerInset = .zero
    #if os(macOS)
        wantsLayer = false
        layer?.backgroundColor = .clear
        backgroundColor = .clear
        
        textContainer?.lineFragmentPadding = 0
    #elseif os(iOS)
        backgroundColor = .clear
        textContainer.lineFragmentPadding = 0
        contentInset = .zero
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
    
    func noSetAlignment(_ alignment: NSTextAlignment) {
    #if os(macOS)
        self.alignment = alignment
    #elseif os(iOS)
        textAlignment = alignment
    #endif
    }
    
    func targetTextSize(targetWidth: CGFloat = 0.0) -> NOSize {
    #if os(macOS)
        guard
            let layoutManager = self.layoutManager, let textContainer = self.textContainer
        else { return .zero }

        // Save existing container size
        let originalSize = textContainer.containerSize

        // Set the target width
        textContainer.containerSize = CGSize(width: targetWidth, height: CGFloat.greatestFiniteMagnitude)

        // Ensure layout for the entire range of text
        let textRange = NSRange(location: 0, length: self.string.utf16.count)
        layoutManager.ensureLayout(forCharacterRange: textRange)

        // Get the range of glyphs that were laid out
        let glyphRange = layoutManager.glyphRange(for: textContainer)

        // Calculate the rectangle that fits these glyphs
        var usedRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)
        
        // Reset to original container size if needed
        textContainer.containerSize = originalSize

        return CGSize(width: ceil(usedRect.size.width), height: ceil(usedRect.size.height))

    #elseif os(iOS)
        let contentSize = sizeThatFits(CGSize(width: targetWidth, height: .greatestFiniteMagnitude))
        return CGSize(width: contentSize.width, height: contentSize.height)
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
