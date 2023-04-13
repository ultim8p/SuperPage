//
//  KeyboardShortcut.swift
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

enum KeyboardShortcut {
    
    case commandP
    
    case commandEnter
    
    case commandN
    
    #if os(macOS)
    var flags: NSEvent.ModifierFlags {
        switch self {
        case .commandP, .commandEnter, .commandN:
            return .command
        }
    }
    #endif

    var keyCodes: [Int] {
        switch self {
        case .commandP:
            return [35] // P
        case .commandEnter:
            return [36] // Return || Enter
        case .commandN:
            return [45] // N
        }
    }
}
