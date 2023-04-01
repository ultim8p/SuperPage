//
//  NavView.swift
//  Atlet
//
//  Created by Guerson Perez on 2/6/23.
//

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif
import SwiftUI

// Main Navigation Screen
// Navigation Controller
struct NavView<Content: View>: View {
    
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        NavigationView {
            NavBarContentView {
                content
            }
            #if !os(macOS)
            .navigationBarHidden(true)
            #else
            #endif
        }
        #if !os(macOS)
        .navigationViewStyle(StackNavigationViewStyle())
        #else
        #endif
        
    }
}

#if !os(macOS)
extension UINavigationController {
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = nil
    }
}
#else
#endif

struct NavView_Previews: PreviewProvider {
    static var previews: some View {
        NavView {
            Color.red.ignoresSafeArea()
        }
    }
}
