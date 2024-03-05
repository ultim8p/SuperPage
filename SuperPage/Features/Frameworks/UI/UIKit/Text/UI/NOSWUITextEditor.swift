//
//  NOSWUITextEditor.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/8/24.
//

import SwiftUI
#if canImport(AppKit)
import AppKit
#endif


struct NOSWUITextEditor: PlatformViewRepresentable {
    
    
#if os(iOS)
    typealias UIViewType = PlatformView
#endif
    
    @Binding var text: String
    @Binding var placeholder: String
    var onShortcut: KeyboardShortcutHandler?
    
    func makeView(ctx: Context) -> PlatformView {
        let textEditor = NOTextEditor()
        textEditor.delegate = ctx.coordinator
        textEditor.noSet(text: text)
        textEditor.noSet(placeholder: placeholder)
        return textEditor
    }
    
    func updateEditor(editor: NOTextEditor, ctx: Context) {
        
        editor.noSet(text: text)
    }
    
#if os(macOS)
    func makeNSView(context: Context) -> some PlatformView {
        makeView(ctx: context)
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        guard let editor = nsView as? NOTextEditor else { return }
        updateEditor(editor: editor, ctx: context)
    }
    
#elseif os(iOS)
    
    func makeUIView(context: Context) -> PlatformView {
        makeView(ctx: context)
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        guard let editor = uiView as? NOTextEditor else { return }
        updateEditor(editor: editor, ctx: context)
    }
#endif
    

    
    func makeCoordinator() -> NOSWUITextEditorCoordinator {
        NOSWUITextEditorCoordinator($text, onShortcut: onShortcut)
    }
}

final class NOSWUITextEditorCoordinator: NOTextEditorDelegate {
    
    var text: Binding<String>
    
    var onShortcut: KeyboardShortcutHandler?
    
    init(_ text: Binding<String>, onShortcut: KeyboardShortcutHandler?) {
        self.text = text
        self.onShortcut = onShortcut
    }
    
    func noTextEditor(_ editor: NOTextEditor, didChangeText text: String) {
        self.text.wrappedValue = text
    }
    
    func noTextEditor(_ editor: NOTextEditor, didPerform shortcut: KeyboardShortcut) {
        self.onShortcut?(shortcut)
    }
}
