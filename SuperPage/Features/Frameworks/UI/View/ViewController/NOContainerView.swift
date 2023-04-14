//
//  NOContainerView.swift
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

/*
class BlockingContainerView: NOView {
    
    var blockMouseEvents: Bool = true
    
    override func hitTest(_ point: NSPoint) -> NSView? {
        if blockMouseEvents {
            return self
        } else {
            return super.hitTest(point)
        }
    }
    
    override func mouseDown(with event: NSEvent) {
        if !blockMouseEvents {
            super.mouseDown(with: event)
        }
    }

    override func mouseUp(with event: NSEvent) {
        if !blockMouseEvents {
            super.mouseUp(with: event)
        }
    }

    override func mouseDragged(with event: NSEvent) {
        if !blockMouseEvents {
            super.mouseDragged(with: event)
        }
    }
}

extension PlatformView {
    
    func addContainer(viewController: PlatformViewControler) {
        let blockingContainerView = BlockingContainerView()
        blockingContainerView.noBackgroundColor = .red.withAlphaComponent(0.2)
        addSubview(blockingContainerView)
        blockingContainerView.onFull(to: self, const: 0.0)
        blockingContainerView.addSubview(viewController.view)
        viewController.view.onFull(to: blockingContainerView)
    }
}
*/
