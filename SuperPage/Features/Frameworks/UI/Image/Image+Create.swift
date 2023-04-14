//
//  Image+Create.swift
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

//extension PlatformImage {
//
//    static func noSymbol(name: String) -> PlatformImage {
//    #if os(macOS)
//        return PlatformImage(systemSymbolName: name, accessibilityDescription: "")!
//    #elseif os(iOS)
//        return UIImage(systemName: name)!
//    #endif
//    }
//}

import Foundation

extension PlatformImage {
    
    static func noSymbol(name: String, tintColor: PlatformColor? = nil, size: CGSize? = nil) -> PlatformImage? {
        let tintColor = tintColor ?? SuperColor.icon
        
        #if os(iOS)
        var config: PlatformImage.SymbolConfiguration
        if let size = size {
            config = PlatformImage.SymbolConfiguration(pointSize: size.height, weight: .bold)
        } else {
            config = PlatformImage.SymbolConfiguration(scale: .large)
        }
        
        var image = PlatformImage(systemName: name, withConfiguration: config)
        
        image = image?.withTintColor(tintColor)
        
        
        return image
        #elseif os(macOS)
        guard let image = PlatformImage(systemSymbolName: name, accessibilityDescription: nil) else { return nil }
        let newSize = size ?? CGSize(width: image.size.width * 1.5, height: image.size.height * 1.5)
        
        let tinted = image.resized(to: newSize).tinted(with: tintColor)
        
        return tinted
        #endif
    }
}

#if os(macOS)
extension NSImage {
    func tinted(with color: NSColor?) -> NSImage {
        guard let color = color else { return self }
        
        let imageRect = NSRect(origin: .zero, size: self.size)
        let tinted = NSImage(size: self.size)
        
        tinted.lockFocus()
        self.draw(in: imageRect)
        color.set()
        imageRect.fill(using: .sourceAtop)
        tinted.unlockFocus()
        
        return tinted
    }
    
    func resized(to newSize: CGSize) -> NSImage {
        let newImage = NSImage(size: newSize)
        newImage.lockFocus()
        self.draw(in: NSRect(origin: .zero, size: newSize), from: .zero, operation: .copy, fraction: 1.0)
        newImage.unlockFocus()
        return newImage
    }
}
#endif
