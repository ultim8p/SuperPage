//
//  LoadAnimationView.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/13/23.
//

import Foundation

#if canImport(AppKit)
import AppKit
#elseif canImport(UIKit)
import UIKit
#endif

class NOSpinner: PlatformActivityIndicator {
    
    static func noSpinner(inView: PlatformView, centerTo: PlatformView) -> NOSpinner {
        let spinner: NOSpinner = {
        #if os(macOS)
            let indicator = NOSpinner()
            indicator.style = .spinning
            indicator.startAnimation(nil)
            return indicator
        #elseif os(iOS)
            let indicator = NOSpinner(style: .medium)
            indicator.color = PlatformColor.gray
            indicator.startAnimating()
            return indicator
        #endif
        }()
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        inView.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: centerTo.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: centerTo.centerYAnchor)
        ])
        return spinner
    }
}
