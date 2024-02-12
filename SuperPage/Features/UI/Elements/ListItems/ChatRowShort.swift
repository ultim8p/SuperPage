//
//  ChatRowShort.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/11/24.
//

import SwiftUI

struct ChatRowShort: View {
    
    let name: String
    
    @Binding var selectedChatId: Chat.ID?
    
    let chat: Chat
    
    var selectionHandler: (() -> Void)?
    
    var body: some View {
        let isSelected = selectedChatId == chat.id
        ZStack {
            HStack(spacing: 0) {
                let imageName: String = SystemImage.folder.rawValue
                
                let font: Font = .system(size: 14, weight: .regular)
                let color: Color = .spDefaultText
                
                let iconColor: Color = .cyan
                Image(systemName: imageName)
                    .foregroundColor(iconColor)
                    .font(font)
                    .frame(width: 22.0, height: 22.0)
                Text(name)
                    .font(font)
                    .foregroundStyle(color)
                    .padding(.leading, 2)
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.trailing, 12)
        }
        .padding(.leading, 0)
        .frame(maxWidth: .infinity)
        .frame(height: 22.0)
        .background(
            Group {
                if isSelected {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(Color.spAction)
                        .padding(.leading, 8)
                        .padding(.trailing, 8)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    Color.clear
                }
            }
        )
        
        .contentShape(Rectangle())
        .onTapGesture {
            selectionHandler?()
        }
    }
}

#Preview {
    ChatRowShort(
        name: "My folder",
        selectedChatId: .constant(nil),
        chat: Chat(),
        selectionHandler: nil
    )
}
