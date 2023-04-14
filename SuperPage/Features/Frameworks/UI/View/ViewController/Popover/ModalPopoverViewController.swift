//
//  ModalPopoverViewController.swift
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

#if os(iOS)
class ModalPopoverViewController: UIViewController {
    
    private let contentViewController: UIViewController
    
    private let size: PlatformSize
        
    init(contentViewController: UIViewController, size: PlatformSize) {
        self.contentViewController = contentViewController
        self.size = size
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    var onDismiss: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        setupContentViewController()
    }

    private func setupContentViewController() {
        addChild(contentViewController)
        view.addSubview(contentViewController.view)
        contentViewController.didMove(toParent: self)

        contentViewController.view.layer.cornerRadius = 10
        contentViewController.view.layer.masksToBounds = true
        contentViewController.view
            .centerX(to: view).safeTop(to: view, const: 80.0)
            .width(size.width).height(size.height)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == self.view {
            dismiss(animated: true) { [weak self] in
                self?.onDismiss?()
            }
        }
    }
}
#endif
