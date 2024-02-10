//
//  EmojiPickerView.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/9/24.
//

import SwiftUI

struct EmojiPickerView: View {
    @Binding var selectedEmoji: String?
    
    let emojiWidth: CGFloat = 43.0  // You can adjust this based on your needs
    let padding: CGFloat = 0.0
    let borderPadding: CGFloat = 10.0
    
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 8)
    let emojiList = fullEmojiList
    
    init(selectedEmoji: Binding<String?>) {
        self._selectedEmoji = selectedEmoji
    }
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: padding) {
                ForEach(emojiList.categories ?? [], id: \.id) { category in
                    Section(header: Text(category.type?.rawValue.capitalized ?? "").font(.title2).bold().padding()) {
                        ForEach(category.emojs ?? [], id: \.self) { emoji in
                            Text(emoji)
                                .font(.title)
                                .padding(5)
                                .background(emoji == selectedEmoji ? Color.gray.opacity(0.3) : Color.clear)
                                .cornerRadius(8)
                                .onTapGesture {
                                    self.selectedEmoji = emoji
                                }
                        }
                    }
                }
            }
            .padding(borderPadding)
        }
        .frame(
            width: CGFloat(columns.count) * (emojiWidth + padding) + (borderPadding * 2.0),
            height: 400.0
        )
    }
}
