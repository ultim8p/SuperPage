//
//  TextView.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/9/23.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension String {
    
    var codeBlockRanges: [NSRange] {
        var ranges: [NSRange] = []
        let pattern = "```(.*?)```"
        let regexOptions: NSRegularExpression.Options = [.dotMatchesLineSeparators]
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: regexOptions)
            let nsString = self as NSString
            let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: nsString.length))
            
            for match in matches {
                let contentRange = match.range(at: 1)
                ranges.append(contentRange)
            }
            
        } catch {
            print("Invalid regex pattern")
        }
        
        return ranges
    }
}

let codeTopOffset: CGFloat = -15.0
let codeHeaderHeight: CGFloat = 30.0
let codeEdgesOffset: CGFloat = 0.0
let codeBottomOffset: CGFloat = 15.0



/*
class AutoSizingTextView: PlatformTextView {
    
    var commandReturnCallback: (() -> Void)?
    
    let backgroundView: PlatformView = {
        #if os(macOS)
        let box = NSBox()
        box.boxType = .custom
        box.fillColor = SuperColor.codeBlock ?? PlatformColor.clear
        box.cornerRadius = 10
        return box
        #elseif os(iOS)
        let view = PlatformView()
        view.backgroundColor = SuperColor.codeBlock
        view.layer.cornerRadius = 10
        return view
        #endif
    }()
    
    private let keywordAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: PlatformColor(red: 255.0/255.0, green: 83.0/255.0, blue: 160.0/255.0, alpha: 1.0),
        .font: PlatformFont.boldSystemFont(ofSize: 15.0)
    ]

    private let typeAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: PlatformColor(red: 197.0/255.0, green: 124.0/255.0, blue: 255.0/255.0, alpha: 1.0),
        .font: PlatformFont.systemFont(ofSize: 15.0)
    ]
    
    private let stringAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: PlatformColor(red: 250.0/255.0, green: 99.0/255.0, blue: 49.0/255.0, alpha: 1.0),
        .font: PlatformFont.systemFont(ofSize: 15.0)
    ]

    private let commentAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: PlatformColor(red: 100.0/255.0, green: 100.0/255.0, blue: 100.0/255.0, alpha: 1.0),
        .font: PlatformFont.systemFont(ofSize: 15.0)
    ]
    
    private let varNameAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: PlatformColor(red: 29.0/255.0, green: 190.0/255.0, blue: 249.0/255.0, alpha: 1.0),
        .font: PlatformFont.systemFont(ofSize: 15.0)
    ]
    
    private let defaultAttributes: [NSAttributedString.Key: Any] = [
        .foregroundColor: SuperColor.defaultText,
        .font: PlatformFont.systemFont(ofSize: 15.0)
    ]
    
    private let swiftKeywords = [
        "class", "deinit", "enum", "extension", "fileprivate", "func", "import", "init", "inout", "internal", "let", "open", "operator", "private", "protocol", "public", "rethrows", "return", "static", "struct", "subscript", "typealias", "var", "break", "case", "continue", "default", "defer", "do", "else", "fallthrough", "for", "guard", "if", "in", "repeat", "switch", "where", "while", "as", "Any", "catch", "false", "is", "nil", "super", "self", "Self", "throw", "throws", "true", "try", "_", "associativity", "convenience", "dynamic", "didSet", "final", "get", "infix", "indirect", "lazy", "left", "mutating", "none", "nonmutating", "optional", "override", "postfix", "precedence", "prefix", "Protocol", "required", "right", "set", "Type", "unowned", "weak", "willSet", "some", "abstract", "boolean", "byte", "catch", "char", "extends", "float", "implements", "instanceof", "int", "interface", "long", "module", "native", "new", "package", "protected", "short", "strictfp", "synchronized", "this", "transient", "void", "volatile", "const", "debugger", "delete", "export", "instanceof", "null", "asm", "auto", "bool", "double", "dynamic_cast", "explicit", "extern", "friend", "goto", "inline", "mutable", "namespace", "reinterpret_cast", "signed", "sizeof", "static_cast", "template", "typeid", "typename", "union", "unsigned", "using", "virtual", "wchar_t", "associatedtype", "indirect", "repeat", "required", "where", "alias", "begin", "defined?", "elsif", "end", "ensure", "next", "not", "or", "redo", "rescue", "retry", "undef", "unless", "until", "when", "yield", "array", "empty", "enddeclare", "endfor", "endforeach", "endif", "endswitch", "endwhile", "eval", "exit", "extends", "final", "finally", "float", "foreach", "function", "global", "if", "implements", "include", "instanceof", "interface", "isset", "list", "namespace", "new", "null", "number_format", "object", "print", "private", "protected", "public", "require", "static", "string", "switch", "throw", "trait", "true", "try", "unset", "use", "var", "while", "xor", "ALTER", "AND", "AS", "ASC", "BETWEEN", "BY", "COUNT", "CREATE", "DELETE", "DESC", "DISTINCT", "DROP", "EXISTS", "FROM", "GROUP", "HAVING", "IN", "INDEX", "INNER", "INSERT", "INTO", "IS", "JOIN", "LIKE", "LIMIT", "NOT", "NULL", "ON", "OR", "ORDER", "OUTER", "SELECT", "SET", "SUM", "TABLE", "UNION", "UNIQUE", "UPDATE", "VALUES", "WHERE", "as?", "fun", "!in", "!is", "object", "@dynamic", "@optional", "@required", "bool", "crate", "debugger", "declare", "export", "implicit", "number", "readonly", "readwrite", "unsafe_unretained", "@autoreleasepool", "@catch", "@class", "@compatibility_alias", "@defs", "@encode", "@end", "@finally", "@implementation", "@interface", "@keypath", "@public", "@package", "@protected", "@private", "@property", "@protocol", "@selector", "@synchronized", "@synthesize", "@throw", "@try", "BOOL", "Class", "IMP", "NO", "Nil", "NULL", "SEL", "YES", "assign", "atomic", "copy", "retain", "strong", "unsafe_unretained", "weak", "@dynamic", "@optional", "@required", "abstract", "checked", "decimal", "do", "event", "fixed", "implicit", "lock", "readonly", "ref", "sbyte", "sealed", "stackalloc", "unchecked", "unsafe", "ushort", "using", "yield", "AAA", "AAD", "AAM", "AAS", "ADC", "ADD", "AND", "CALL", "CBW", "CLC", "CLD", "CLI", "CMC", "CMP", "CWD", "DAA", "DAS", "DEC", "DIV", "ESC", "HLT", "IDIV", "IMUL", "IN", "INC", "INT", "INTO", "IRET", "JA", "JC", "JCXZ", "JE", "JG", "JMP", "JNA", "JNC", "JNE", "JNG", "JNO", "JNP", "JNS", "JNZ", "JO", "JP", "JPE", "JPO", "JS", "JZ", "LAHF", "LDS", "LEA", "LES", "LOCK", "LODSB", "LODSW", "LOOP", "LOOPE", "LOOPNE", "LOOPNZ", "LOOPZ", "MOV", "MOVSB", "MOVSW", "MUL", "NEG", "NOP", "NOT", "OR", "OUT", "POP", "POPF", "PUSH", "PUSHF", "RCL", "RCR", "RET", "RETF", "REPNZ", "REPZ", "RETN", "SAHF", "SBB", "SCASB", "SCASW", "SHL", "SHR", "STC", "STD", "STI", "STOSB", "STOSW", "SUB", "TEST", "WAIT", "XCHG", "XLAT", "XOR", "auto", "register", "restrict", "typedef", "char", "double", "float", "int", "long", "short", "signed", "unsigned", "void", "volatile", "absolute", "and", "array", "asm", "begin", "case", "const", "constructor", "continue", "decrement", "div", "dword", "else", "end", "except", "exit", "export", "false", "file", "finalization", "finally", "for", "function", "goto", "if", "implementation", "in", "increment", "inherited", "initialization", "inline", "interface", "is", "label", "library", "mod", "nil", "not", "of", "on", "operator", "packed", "procedure", "program", "property", "real", "record", "repeat", "set", "shl", "shr", "string", "then", "threadvar", "to", "true", "try", "type", "unit", "until", "uses", "val", "while", "with", "word", "xor"
    ]
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var codeRanges: [NSRange] = []
    var textFormatters: [TextFormatter] = []
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func textDidChange() {
        let fullRange = NSRange(location: 0, length: noText.utf16.count)
        #if os(macOS)
        textStorage?.setAttributes(defaultAttributes, range: fullRange)
        #elseif os(iOS)
        textStorage.setAttributes(defaultAttributes, range: fullRange)
        #endif
        
        codeRanges = noText.codeBlockRanges
        
        /*
        highlightKeywords()
        highlightTypes()
        highlightVars()
        highlightStrings()
        highlightComments()
         */
    }
    
    
    
    
    /*
    func add(attributes: [NSAttributedString.Key: Any], regex: NSRegularExpression?, range: NSRange) {
#if os(macOS)
        guard let textStorage else { return }
#endif
        regex?.enumerateMatches(in: platformText, options: [], range: range) { result, _, _ in
            guard let result = result else { return }
            textStorage.addAttributes(attributes, range: result.range)
        }
    }
    */
    
    
    
    
    /*
    private func highlightKeywords() {
        let regexPattern = "\\b(" + swiftKeywords.joined(separator: "|") + ")\\b"
        let regex = try? NSRegularExpression(pattern: regexPattern, options: [])
        codeRanges.forEach({ add(attributes: keywordAttributes, regex: regex, range: $0) })
    }
    
    private func highlightTypes() {
        let regex = try? NSRegularExpression(pattern: "\\b([A-Z][a-zA-Z0-9_]+)\\b|^(?=@)\\S+|@\\S+", options: [])
        codeRanges.forEach({ add(attributes: typeAttributes, regex: regex, range: $0) })

    }
    
    private func highlightVars() {
        let regexPattern = "[.$&*#!^](?<=[.$&*#!^])[a-zA-Z0-9.$&*#!^]+.*?(?=[^a-zA-Z0-9.$&*#!^]|$)"
        let regex = try? NSRegularExpression(pattern: regexPattern)
        codeRanges.forEach({ add(attributes: varNameAttributes, regex: regex, range: $0) })
    }
    
    private func highlightComments() {
        let pattern1 = "(?<=\\s|^)//[^\\r\\n]*"
        let pattern2 = #"[<!---->](?<=<!--).*?(?=-->)"#
        let pattern3 = #"[/**/]/(\/\*[\S\s]*?\*\/|\/\/.*|<!--[\S\s]*?-->)/g"#
        
        let regexPattern = "\(pattern1)|\(pattern2)|\(pattern3)"
        let regex = try? NSRegularExpression(pattern: regexPattern, options: [])
        
        codeRanges.forEach({ add(attributes: commentAttributes, regex: regex, range: $0) })
    }
    
    private func highlightStrings() {
        let regex = try? NSRegularExpression(pattern: "\"(.*?)\"", options: [])
        
        codeRanges.forEach({ add(attributes: stringAttributes, regex: regex, range: $0) })
    }
    */
#if os(macOS)
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
    }
#endif
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        let layoutManager = NSLayoutManager()
        let textStorage = NSTextStorage()
        textStorage.addLayoutManager(layoutManager)
        
        if let textContainer = textContainer {
            textContainer.widthTracksTextView = true
            layoutManager.addTextContainer(textContainer)
        } else {
            let container = NSTextContainer()
            container.widthTracksTextView = true
            layoutManager.addTextContainer(container)
        }
        super.init(frame: frame, textContainer: textContainer)
//        self.minSize = NSSize(width: 100.0, height: 100.0)
//        self.isVerticallyResizable = true
//        self.isHorizontallyResizable = true
//        self.autoresizingMask = .width
        
        
//        print("CONTAINERS: \(self.layoutManager?.textContainers.count)")
//        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: PlatformTextView.textDidChangeNotification, object: self)
    }
    
#if os(macOS)
    override func didChangeText() {
        super.didChangeText()
        print("DID CHNG TXT: \(string)")
        
        textDidChange()
        invalidateIntrinsicContentSize()
    }
#endif
    
    #if os(iOS)
    override func layoutSubviews() {
        super.layoutSubviews()
        codeRanges.forEach { range in
            // Add the custom background view behind the text in the custom range
            let textRange = layoutManager.characterRange(forGlyphRange: NSRange(location: 0, length: self.noText.count), actualGlyphRange: nil)
            let boundingRect = layoutManager.boundingRect(forGlyphRange: textRange, in: textContainer)
            let customRect = layoutManager.boundingRect(forGlyphRange: range, in: textContainer)
            let customViewRect = CGRect(
                x: boundingRect.origin.x + customRect.origin.x - codeEdgesOffset,
                y: (boundingRect.origin.y + customRect.origin.y) - (codeHeaderHeight + codeTopOffset),
                width: customRect.width + (codeEdgesOffset * 2.0),
                height: customRect.height + (codeHeaderHeight + codeTopOffset + codeBottomOffset))
            backgroundView.frame = customViewRect
            self.insertSubview(backgroundView, at: 0)
        }
    }
    #endif
    
    override var intrinsicContentSize: CGSize {
        #if os(macOS)
        
        guard let layoutManager = layoutManager, let textContainer = textContainer
                , let scrollViewSize = self.enclosingScrollView?.bounds.size
        else {
//            print("textView no layoutManager or textContainer: \(platformText)")
            return .zero
        }
        layoutManager.textContainerChangedGeometry(textContainer)
//        print("GETTING INTRISNIC SIZE: \(scrollViewSize) MIN SIZE: \(minSize)")
        layoutManager.ensureLayout(for: textContainer)
//        let size = CGSize(width: scrollViewSize.width, height: 3000)
        let usedRect = layoutManager.usedRect(for: textContainer).size
        
        return usedRect
        #elseif os(iOS)
        let contentSize = sizeThatFits(CGSize(width: bounds.width, height: .greatestFiniteMagnitude))
        return CGSize(width: bounds.width, height: contentSize.height)
        #endif
    }
    
    
#if os(macOS)
    override func keyDown(with event: NSEvent) {
        if event.modifierFlags.contains(.command) && event.keyCode == 36 {
            commandEnterPressed()
        } else {
            super.keyDown(with: event)
        }
    }
#endif
    
    func commandEnterPressed() {
            // Perform your desired action here
            print("Command + Enter pressed")
        commandReturnCallback?()
    }
}

struct ResizableTextView: PlatformViewRepresentable {
    
    #if os(macOS)
    typealias NSViewType = AutoSizingTextView
    #endif
    
    @Binding var text: String
    
    var backColor: PlatformColor?
    
    var onCommandReturn: (() -> Void)?
    
    var onHeightChange: ((CGFloat) -> Void)?
    
    var onScrollChange: ((CGFloat) -> Void)?
    
    // MARK: ViewRepresentable
    
    func makeNSView(context: Context) -> AutoSizingTextView {
       makeView(context: context)
    }
    
    func updateNSView(_ nsView: AutoSizingTextView, context: Context) {
        updateView(nsView, context: context)
    }
    
    func updateUIView(_ uiView: AutoSizingTextView, context: Context) {
       updateView(uiView, context: context)
    }

    func makeUIView(context: Context) -> AutoSizingTextView {
        makeView(context: context)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

        // MARK: - RepresentableHandling

    func makeView(context: Context) -> AutoSizingTextView {
        let textView = AutoSizingTextView()
        
        #if os(macOS)
        textView.textContainerInset = NSSize.zero
        textView.delegate = context.coordinator
        
        #elseif os(iOS)
        textView.delegate = context.coordinator
        textView.isScrollEnabled = false
        textView.textContainer.lineFragmentPadding = 0
        textView.textContainerInset = .zero
        #endif
        textView.commandReturnCallback = onCommandReturn
//        textView.isEditable = false
        textView.backgroundColor = backColor ?? .clear

        return textView
    }
    
    func updateView(_ view: AutoSizingTextView, context: Context) {
        #if os(macOS)
        view.string = text
        view.didChangeText()
        #elseif os(iOS)
        view.text = text
        #endif
        view.textDidChange()
        print("TEXT DID CHANGE: \(text)")
        DispatchQueue.main.async {
            view.invalidateIntrinsicContentSize()
        }
    }
    
#if os(macOS)
#elseif os(iOS)
#endif
    
    class Coordinator: NSObject, PlatformTextViewDelegate {
        var parent: ResizableTextView

        init(_ parent: ResizableTextView) {
            self.parent = parent
        }
        
#if os(macOS)
        func textDidChange(_ notification: Notification) {
//            guard let textView = notification.object as? NSTextView else { return }
//            DispatchQueue.main.async {
//                self.parent.onHeightChange?(20.0)
//            }
            
            
            guard let textView = notification.object as? NSTextView else { return }
                        self.parent.text = textView.string
//                        let newSize = textView.sizeThatFits(textView.frame.size)
            parent.onHeightChange?(20.0)
                        
                        if let scrollView = textView.enclosingScrollView {
                            let offset = scrollView.contentView.bounds.origin.y
                            parent.onScrollChange?(offset)
                        }
        }
#elseif os(iOS)
        func textViewDidChange(_ textView: PlatformTextView) {
            self.parent.onHeightChange?(20.0)
        }
#endif
    }
}
*/
