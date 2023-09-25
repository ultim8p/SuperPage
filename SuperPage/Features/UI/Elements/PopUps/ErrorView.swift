//
//  ErrorView.swift
//  SuperPage
//
//  Created by Guerson Perez on 9/18/23.
//

import Foundation
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#elseif canImport(Cocoa)
import Cocoa
#endif

class ErrorView: NOView {
    
    var errorLabel = NOTextView(frame: .zero, textContainer: nil)
    
    override init() {
        super.init()
        
        noBackgroundColor = SuperColor.alert
        noSet(radius: 5.0)
        
        addSubview(errorLabel)
        errorLabel.formatters = [TextFormat.defaultText(12)]
        errorLabel.noSetAlignment(.left)
        errorLabel.isSelectable = false
        errorLabel.isEditable = false
        errorLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        errorLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        errorLabel.setContentHuggingPriority(.required, for: .vertical)
        errorLabel.setContentHuggingPriority(.required, for: .horizontal)
        errorLabel
            .lead(to: self, const: 6.0)
            .trail(to: self, const: 6.0)
            .top(to: self, const: 6.0)
            .bottom(to: self, const: 6.0)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(error: NoError?) {
        let textSize = errorLabel.targetTextSize(targetWidth: self.bounds.size.width - 12.0)
        errorLabel.height(textSize.height).width(textSize.width)
        errorLabel.noSetText(text: error?.reason ?? "")
        reloadLayoutIfNeeded()
    }
}
