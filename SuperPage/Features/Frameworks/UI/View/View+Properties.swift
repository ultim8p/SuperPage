//
//  View+Properties.swift
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

class NOView: PlatformView {
    
    var noBackgroundColor: PlatformColor = .clear {
        didSet {
    #if os(macOS)
            needsDisplay = true
#elseif os(iOS)
            backgroundColor = noBackgroundColor
#endif
        }
    }

#if os(macOS)
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        noBackgroundColor.setFill()
        dirtyRect.fill()
    }
#endif
}

//extension PlatformView {
//    func set(backgroundColor: PlatformColor) {
//    #if os(macOS)
//        wantsLayer = true
//        layer?.backgroundColor = backgroundColor.cgColor
//    #elseif os(iOS)
//        self.backgroundColor = backgroundColor
//    #endif
//    }
//}
