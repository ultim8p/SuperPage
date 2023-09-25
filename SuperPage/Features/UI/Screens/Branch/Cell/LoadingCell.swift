//
//  LoadingCell.swift
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

class LoadingCell: PCollectionViewCell, ClassNameProtocol {
    
    var loadingView: LottieView!
    
    #if os(macOS)
    override func loadView() {
        self.view = NSView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCardView()
    }
    
    #elseif os(iOS)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCardView()
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCardView()
    }
    #endif
    
    override func prepareForReuse() {
            super.prepareForReuse()
            
        }
    
    private func setupCardView() {
        loadingView = LottieView(animationName: "loadingDots", inView: noContentView)
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: noContentView.leadingAnchor, constant: 0),
            loadingView.trailingAnchor.constraint(equalTo: noContentView.trailingAnchor, constant: 0),
            loadingView.topAnchor.constraint(equalTo: noContentView.topAnchor, constant: 0),
            loadingView.bottomAnchor.constraint(equalTo: noContentView.bottomAnchor, constant: 0),
        ])
        
//        noContentView.addSubview(cardView)
//        cardView.translatesAutoresizingMaskIntoConstraints = false
//        NSLayoutConstraint.activate([
//            cardView.leadingAnchor.constraint(equalTo: noContentView.leadingAnchor, constant: 0),
//            cardView.trailingAnchor.constraint(equalTo: noContentView.trailingAnchor, constant: 0),
//            cardView.topAnchor.constraint(equalTo: noContentView.topAnchor, constant: 0),
//            cardView.bottomAnchor.constraint(equalTo: noContentView.bottomAnchor, constant: 0),
//        ])
//        cardView.noBackgroundColor = .clear
//
//        loadingIndicator = NOSpinner.noSpinner(inView: noContentView, centerTo: noContentView)
//        loadingIndicator.startAnimating()
//        noContentView.layoutIfNeeded()
//        print("SPINEER: \(loadingIndicator)")

    }
}
