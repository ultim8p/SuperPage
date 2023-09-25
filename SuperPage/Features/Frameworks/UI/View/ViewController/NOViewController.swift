//
//  NOViewController.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/14/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

class NOViewController: PlatformViewControler {
    
    func noSet(backgroundColor: NOColor) {
    #if os(macOS)
        (view as? NOView)?.noBackgroundColor = backgroundColor
    #elseif os(iOS)
        view.backgroundColor = backgroundColor
    #endif
    }
#if os(macOS)
    override func loadView() {
        view = NOView()
    }
#elseif os(iOS)
#endif
}
