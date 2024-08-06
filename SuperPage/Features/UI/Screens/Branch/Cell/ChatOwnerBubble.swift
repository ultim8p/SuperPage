//
//  ChatOwnerBubble.swift
//  SuperPage
//
//  Created by Guerson Perez on 9/9/23.
//

import Foundation
import NoUI

class ChatOwnerBubble: NOView {
    
    let nameLabel = NOTextView(frame: .zero, textContainer: nil)
    
    enum Constant {
        static let verticalSpace: CGFloat = 3.0
        static let horizontalSpace: CGFloat = 5.0
    }
    
    override init() {
        super.init()
        
        addSubview(nameLabel)
        nameLabel.isEditable = false
        nameLabel.isSelectable = false
        nameLabel.noSetAlignment(.left)
        nameLabel.formatters = [TextFormat.defaultText(10)]
        nameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        nameLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        nameLabel.setContentHuggingPriority(.required, for: .vertical)
        nameLabel.setContentHuggingPriority(.required, for: .horizontal)
        nameLabel
            .onCenter(to: self)
    }
    
    func configure(_ message: Message?) {
        let isUser = message?.role == .user
        let modelString: String = isUser ? "User" : message?.model?.displayName ?? ""
        noBackgroundColor = isUser ? SuperColor.indicatorUser : SuperColor.indicatorAIModel
        nameLabel.noSetText(text: modelString, size: NOSize(width: 20000, height: 2000))
        let textSize = nameLabel.targetTextSize(targetWidth: 1000.0)
        nameLabel.noSetText(text: modelString, size: textSize)
        nameLabel
            .height(textSize.height)
            .width(textSize.width)
        updateRadius(textHeight: textSize.height)
        
        let bubbleWidth = textSize.width + (Constant.horizontalSpace * 2.0)
        let bubbleHeight = textSize.height + (Constant.verticalSpace * 2.0)
        width(bubbleWidth, priority: .priority10)
        height(bubbleHeight, priority: .priority10)
    }
    
    func updateRadius(textHeight: CGFloat) {
        let radius = (textHeight + (Constant.verticalSpace * 2.0)) * 0.5
        noSet(radius: radius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
