//
//  EmojiSelectView.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/9/24.
//

import SwiftUI

struct EmojiSelectView: View {
    
    var emoji: String?
    
    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 38, height: 38)
            
            if let emoji = emoji, !emoji.isEmpty {
                Text(emoji)
                    .font(.title)
            } else {
                Image(systemName: SystemImage.faceDashedFill.rawValue)
                    .font(.title)
            }
        }
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 6, height: 6)))
    }
}
