//
//  NOPopoverViewController.swift
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

class NOPopoverViewController: PlatformViewControler {
    
    let contentViewController: PlatformViewControler
    
    var dismissHandler: (() -> Void)?
    
    #if os(macOS)
   private var popover: NSPopover?
   #elseif os(iOS)
   private weak var noPresentedViewController: UIViewController?
   #endif
    
    init(contentViewController: PlatformViewControler) {
        self.contentViewController = contentViewController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func show(in viewController: PlatformViewControler, fromRect: PlatformRect, relativeTo: PlatformRect, size: NOSize) {
        #if os(macOS)
        contentViewController.view.setFrameSize(size)
        let newPopover = NSPopover()
        newPopover.contentViewController = contentViewController
        newPopover.behavior = .semitransient
        newPopover.delegate = self
        newPopover.show(relativeTo: fromRect, of: viewController.view, preferredEdge: .maxY)
        popover = newPopover
        #elseif os(iOS)
        contentViewController.preferredContentSize = size
        if UIDevice.current.userInterfaceIdiom == .pad {
            contentViewController.modalPresentationStyle = .popover
            if let popoverPresentationController = contentViewController.popoverPresentationController {
                popoverPresentationController.permittedArrowDirections = .any
                popoverPresentationController.sourceView = view
                popoverPresentationController.sourceRect = fromRect
                popoverPresentationController.delegate = self
                contentViewController.presentationController?.delegate = self
            }
            viewController.present(contentViewController, animated: true, completion: nil)
            noPresentedViewController = contentViewController
        } else {
            let modalPopoverViewController = ModalPopoverViewController(
                contentViewController: contentViewController,
                size: size)
            modalPopoverViewController.modalPresentationStyle = .overFullScreen
            modalPopoverViewController.modalTransitionStyle = .crossDissolve
            modalPopoverViewController.onDismiss = { [weak self] in
                self?.dismissHandler?()
            }
            viewController.present(modalPopoverViewController, animated: true, completion: nil)
            noPresentedViewController = modalPopoverViewController
        }
        #endif
    }
    
    func noDismiss(animated: Bool, completion: (() -> Void)? = nil) {
        #if os(macOS)
        popover?.performClose(nil)
        popover = nil
        completion?()
        #elseif os(iOS)
        noPresentedViewController?.dismiss(animated: animated, completion: completion)
        noPresentedViewController = nil
        dismissHandler?()
        #endif
    }
    
    func onDismiss(handler: (() -> Void)?) {
        dismissHandler = handler
    }
}

#if os(macOS)
extension NOPopoverViewController: NSPopoverDelegate {
    
    func popoverWillClose(_ notification: Notification) {
        
    }
    
    func popoverDidClose(_ notification: Notification) {
        dismissHandler?()
    }
}
#endif

#if os(iOS)
extension NOPopoverViewController: UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func popoverPresentationControllerDidDismissPopover(_ popoverPresentationController: UIPopoverPresentationController) {
        dismissHandler?()
    }
    
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        dismissHandler?()
    }
}
#endif
