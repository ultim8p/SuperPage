//
//  NOSWUITextEditor.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/8/24.
//

import SwiftUI
import AppKit

struct NOSWUITextEditor: NSViewRepresentable {
    
    @Binding var text: String
    @Binding var placeholder: String
    
    func makeNSView(context: Context) -> some PlatformView {
        let textEditor = NOTextEditor()
        textEditor.delegate = context.coordinator
        textEditor.noSet(text: text)
        textEditor.noSet(placeholder: placeholder)
        return textEditor
    }
    
    func updateNSView(_ nsView: NSViewType, context: Context) {
        guard let editor = nsView as? NOTextEditor else { return }
        editor.noSet(text: text)
    }
    
    func makeCoordinator() -> NOSWUITextEditorCoordinator {
        NOSWUITextEditorCoordinator($text)
    }
}

final class NOSWUITextEditorCoordinator: NOTextEditorDelegate {
    
    var text: Binding<String>
    
    init(_ text: Binding<String>) {
        self.text = text
    }
    
    func noTextEditor(_ editor: NOTextEditor, didChangeText text: String) {
        self.text.wrappedValue = text
    }
}
