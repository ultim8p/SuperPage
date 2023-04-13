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
    
    static func noButton(systemName: String) -> PlatformButton {
        let button = PlatformButton()
        let image = PlatformImage.noSymbol(name: systemName)
    #if os(macOS)
        button.isBordered = false
        button.image = image
    #elseif os(iOS)
        button.setImage(image, for: .normal)
        #endif
        return button
    }
}
