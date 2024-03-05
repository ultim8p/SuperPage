//
//  Button+Create.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/13/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

extension PlatformButton {
    
    static func noButton(image: SystemImage, tintColor: NOColor? = nil, size: CGSize? = nil) -> PlatformButton {
        let button = PlatformButton()
        let image = NOImage.noSymbol(name: image.rawValue, tintColor: tintColor, size: size)
        
        #if os(macOS)
        button.isBordered = false
        button.image = image
        #elseif os(iOS)
        button.setImage(image, for: .normal)
        #endif
        
        return button
    }
    
    func noSetImage(_ image: SystemImage, tintColor: NOColor? = nil, size: CGSize? = nil) {
        let image = NOImage.noSymbol(name: image.rawValue, tintColor: tintColor, size: size)
        
        #if os(macOS)
        self.image = image
        #elseif os(iOS)
        setImage(image, for: .normal)
        #endif
    }
    
    func no(setTitle: String) {
        let attributedString = NSMutableAttributedString(string: setTitle)
        attributedString.addAttribute(.font, value: NOFont.systemFont(ofSize: 16.0), range: NSRange(location: 0, length: attributedString.length))
        attributedString.addAttribute(.foregroundColor, value: SuperColor.icon, range: NSRange(location: 0, length: attributedString.length))
    #if os(macOS)
        attributedTitle = attributedString
        isBordered = false
    #elseif os(iOS)
        setAttributedTitle(attributedString, for: .normal)
    #endif
    }
}
