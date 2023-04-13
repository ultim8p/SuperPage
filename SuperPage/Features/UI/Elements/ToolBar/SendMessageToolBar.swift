//
//  SendMessageToolBar.swift
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

class SendMessageToolBar: NOView {
    
//    private let toolbar: PlatformView = {
//        let view = PlatformView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.set(backgroundColor: PlatformColor.gray)
//        return view
//    }()
    
    var sendHandler: (() -> Void)?
    
    let contentView: NOView = {
        let view = NOView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var spinner: NOSpinner!
    
    var widthConstraint: NSLayoutConstraint!
    
    let sendButton: PlatformButton = {
        let button = PlatformButton.noButton(systemName: SystemImage.paperplaneFill.rawValue)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(frame frameRect: PlatformRect) {
        super.init(frame: frameRect)
        translatesAutoresizingMaskIntoConstraints = false
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(loading: Bool) {
        spinner.isHidden = !loading
        sendButton.isHidden = loading
    }
    
    func setupView() {
        addSubview(contentView)
        contentView.addSubview(sendButton)
        
    #if os(macOS)
        sendButton.target = self
        sendButton.action = #selector(sendButtonTapped)
    #elseif os(iOS)
        sendButton.addTarget(self, action: #selector(sendButtonTapped), for: .touchUpInside)
    #endif
        NSLayoutConstraint.activate([
            contentView.centerXAnchor.constraint(equalTo: centerXAnchor),
            contentView.bottomAnchor.constraint(equalTo: bottomAnchor),
            contentView.topAnchor.constraint(equalTo: topAnchor),
            sendButton.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            sendButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        spinner = NOSpinner.noSpinner(inView: contentView, centerTo: sendButton)
    }
    
    static func setup(in view: PlatformView, handler: (() -> Void)?) -> SendMessageToolBar {
        let toolBar = SendMessageToolBar(frame: .zero)
        toolBar.sendHandler = handler
        toolBar.contentView.noBackgroundColor = PlatformColor(named: "toolBarColor")!
        view.addSubview(toolBar)
        
        NSLayoutConstraint.activate([
            toolBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            toolBar.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            toolBar.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        toolBar.widthConstraint = toolBar.contentView.widthAnchor.constraint(equalToConstant: NODevice.readableWidth(for: view.bounds.size.width))
        toolBar.widthConstraint.isActive = true
        
        return toolBar
    }
        
    @objc private func sendButtonTapped() {
        sendHandler?()
    }
    
    func reloadConstraints() {
        let width = NODevice.readableWidth(for: self.bounds.size.width)
        widthConstraint.constant = width
        reloadLayoutIfNeeded()
    }
}
