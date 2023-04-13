//
//  TextView+Extensions.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/12/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

extension PlatformTextView {
    
    var noText: String {
    #if os(macOS)
        return string
    #elseif os(iOS)
        return text
    #endif
    }
}

extension PlatformTextView {
    
    func noEmptyText() {
    #if os(macOS)
        string = ""
        let attributedString = NSAttributedString(string: "")
        textStorage?.setAttributedString(attributedString)
    #elseif os(iOS)
        text = nil
        let attributedString = NSAttributedString(string: "")
        textStorage.setAttributedString(attributedString)
    #endif
    }
}

extension PlatformTextView {
    
    func noBecomeFirstResponder() {
    #if os(macOS)
        window?.makeFirstResponder(self)
    #elseif os(iOS)
        becomeFirstResponder()
    #endif
    }
}
