//
//  NOLayout.swift
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


class NOConstraints {
    var leading: NSLayoutConstraint?
    var trailing: NSLayoutConstraint?
    var top: NSLayoutConstraint?
    var bottom: NSLayoutConstraint?
    var width: NSLayoutConstraint?
    var height: NSLayoutConstraint?
    var centerX: NSLayoutConstraint?
    var centerY: NSLayoutConstraint?
}



#if os(macOS)

extension PlatformView {
    private struct AssociatedKeys {
        static var constaints = "constaints"
    }
    
    var noConstraints: NOConstraints {
        get {
            if let constaints = objc_getAssociatedObject(self, &AssociatedKeys.constaints) as? NOConstraints {
                return constaints
            } else {
                let constaints = NOConstraints()
                objc_setAssociatedObject(self, &AssociatedKeys.constaints, constaints, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return constaints
            }
        }
    }
    
    @discardableResult
    func lead(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: const)
        noConstraints.leading = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func trail(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -const)
        noConstraints.trailing = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func top(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: const)
        noConstraints.top = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func bottom(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -const)
        noConstraints.bottom = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func width(_ const: CGFloat) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: const)
        noConstraints.width = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func height(_ const: CGFloat) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: const)
        noConstraints.height = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func centerX(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: const)
        noConstraints.centerX = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }

    @discardableResult
    func centerY(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: const)
        noConstraints.centerY = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
}

#elseif os(iOS)

extension UIView {
    private struct AssociatedKeys {
        static var constaints = "constaints"
    }

    var noConstraints: NOConstraints {
        get {
            if let constaints = objc_getAssociatedObject(self, &AssociatedKeys.constaints) as? NOConstraints {
                return constaints
            } else {
                let constaints = NOConstraints()
                objc_setAssociatedObject(self, &AssociatedKeys.constaints, constaints, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
                return constaints
            }
        }
    }

    @discardableResult
    func lead(to view: UIView, const: CGFloat = 0.0) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: const)
        noConstraints.leading = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }

    @discardableResult
    func trail(to view: UIView, const: CGFloat = 0.0) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -const)
        noConstraints.trailing = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }

    @discardableResult
    func top(to view: UIView, const: CGFloat = 0.0) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.topAnchor.constraint(equalTo: view.topAnchor, constant: const)
        noConstraints.top = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }

    @discardableResult
    func bottom(to view: UIView, const: CGFloat = 0.0) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -const)
        noConstraints.bottom = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }

    @discardableResult
    func width(_ const: CGFloat) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.widthAnchor.constraint(equalToConstant: const)
        noConstraints.width = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }

    @discardableResult
    func height(_ const: CGFloat) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.heightAnchor.constraint(equalToConstant: const)
        noConstraints.height = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }

    @discardableResult
    func centerX(to view: UIView, const: CGFloat = 0.0) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: const)
        noConstraints.centerX = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }

    @discardableResult
    func centerY(to view: UIView, const: CGFloat = 0.0) -> UIView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = self.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: const)
        noConstraints.centerY = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
}
#endif


extension PlatformView {
    
    
    @discardableResult
    func safeTrail(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: const)
        noConstraints.trailing = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func safeLead(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: const)
        noConstraints.leading = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func safeTop(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: const)
        noConstraints.top = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func safeBottom(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: const)
        noConstraints.bottom = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func onTop(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = bottomAnchor.constraint(equalTo: view.topAnchor, constant: const)
        noConstraints.bottom = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func onBottom(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = topAnchor.constraint(equalTo: view.bottomAnchor, constant: const)
        noConstraints.top = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func onRight(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: const)
        noConstraints.leading = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func onLeft(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        self.translatesAutoresizingMaskIntoConstraints = false
        let constraint = trailingAnchor.constraint(equalTo: view.leadingAnchor, constant: const)
        noConstraints.trailing = constraint
        NSLayoutConstraint.activate([constraint])
        return self
    }
    
    @discardableResult
    func onFull(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        return self.lead(to: view, const: const)
            .trail(to: view, const: const)
            .top(to: view, const: const)
            .bottom(to: view, const: const)
    }
    
    @discardableResult
    func onFullTop(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        return self.lead(to: view, const: const).top(to: view, const: const).trail(to: view, const: const)
    }
    
    @discardableResult
    func onFullBottom(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        return self.lead(to: view, const: const).bottom(to: view, const: const).trail(to: view, const: const)
    }
    
    
    @discardableResult
    func onFullRight(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        return self.trail(to: view, const: const).top(to: view, const: const).bottom(to: view, const: const)
    }
    
    @discardableResult
    func onFullLeft(to view: PlatformView, const: CGFloat = 0.0) -> PlatformView {
        return self.lead(to: view, const: const).top(to: view, const: const).bottom(to: view, const: const)
    }
    
    @discardableResult
    func onSize(const: CGFloat) -> PlatformView {
        return self.width(const).height(const)
    }
}
