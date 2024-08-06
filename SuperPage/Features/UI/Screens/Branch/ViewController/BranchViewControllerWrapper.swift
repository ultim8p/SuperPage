//
//  BranchViewControllerWrapper.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/13/23.
//

import Foundation
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

struct BranchViewControllerWrapper: PlatformViewControlerRepresentable {
    
    @Binding var selectedBranchRef: BranchReference?
    
    @ObservedObject var branchEditState: BranchEditState
    
#if os(macOS)
    typealias NSViewControllerType = BranchViewController
    
    func makeNSViewController(context: Context) -> BranchViewController {
        return makeViewController()
    }
    
    func updateNSViewController(_ nsViewController: BranchViewController, context: Context) {
        updateViewController(nsViewController, context: context)
        
    }
#elseif os(iOS)
    typealias UIViewControllerType = BranchViewController
    
    func makeUIViewController(context: Context) -> BranchViewController {
        return makeViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        updateViewController(uiViewController, context: context)
    }
#endif
    
    func makeViewController() -> BranchViewController {
        let viewController = BranchViewController(branchEditState: branchEditState)
        
        return viewController
    }
    
    func updateViewController(_ viewController: BranchViewController, context: Context) { }
}
