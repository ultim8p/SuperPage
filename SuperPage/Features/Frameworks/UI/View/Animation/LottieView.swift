//
//  LottieView.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/13/23.
//

import Foundation
import Lottie
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

class LottieView: NOView {
    private var animationView: LottieAnimationView

    init(animationName: String, inView: PlatformView) {
        self.animationView = LottieAnimationView()
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        inView.addSubview(self)
        self.setup(animationName: animationName)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup(animationName: String) {
        self.animationView.animation = LottieAnimation.named(animationName)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.animationView.loopMode = .loop
        self.addSubview(self.animationView)
        
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: trailingAnchor),
            animationView.topAnchor.constraint(equalTo: topAnchor),
            animationView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        self.animationView.play()
    }
}
