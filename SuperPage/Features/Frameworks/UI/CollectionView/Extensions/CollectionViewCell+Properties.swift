//
//  CollectionViewCell+Properties.swift
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

extension PlatformCollectionViewCell {
    var noContentView: PlatformView {
    #if os(macOS)
        return view
    #elseif os(iOS)
        return contentView
    #endif
    }
}
