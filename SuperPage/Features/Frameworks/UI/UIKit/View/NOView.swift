//
//  NOView.swift
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
    
    #if os(macOS)
    var trackingArea: NSTrackingArea?
    #endif
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        noBackgroundColor = .clear
    #if os(macOS)
        wantsLayer = true
    #endif
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var noBackgroundColor: NOColor = .clear {
        didSet {
    #if os(macOS)
            needsDisplay = true
            layer?.backgroundColor = noBackgroundColor.cgColor
    #elseif os(iOS)
            backgroundColor = noBackgroundColor
    #endif
        }
    }
    
    func noSet(radius: CGFloat) {
    #if os(macOS)
        layer?.cornerRadius = radius
    #elseif os(iOS)
        layer.cornerRadius = radius
    #endif
    }
    
    typealias HoverHandler = ((_ mouseOn: Bool) -> Void)
    typealias TapHandler = (() -> Void)
    
    var hoverHandler: HoverHandler?
    var tapHandler: TapHandler?
    
    func onHover(_ handler: HoverHandler?) {
        hoverHandler = handler
    }
    
    func onTap(_ handler: TapHandler?) {
        tapHandler = handler
    }
    
    // MARK: - ACTIONS
    #if os(macOS)
    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        
        if let trackingArea = self.trackingArea {
            self.removeTrackingArea(trackingArea)
        }
        
        trackingArea = NSTrackingArea(
            rect: bounds,
            options: [.mouseEnteredAndExited, .activeAlways],
            owner: self,
            userInfo: nil
        )
        
        if let trackingArea = trackingArea {
            self.addTrackingArea(trackingArea)
        }
    }
    
    override func mouseEntered(with event: NSEvent) {
        hoverHandler?(true)
    }
    
    override func mouseExited(with event: NSEvent) {
        hoverHandler?(false)
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        tapHandler?()
    }
    
    #endif
//#if os(macOS)
//    override func draw(_ dirtyRect: NSRect) {
//        super.draw(dirtyRect)
//        noBackgroundColor.setFill()
//        dirtyRect.fill()
//    }
//#endif
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
