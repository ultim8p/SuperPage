//
//  SuperTextEditor.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/9/24.
//

import SwiftUI

struct SuperTextEditor: View {
    
    @Binding var text: String
    @Binding var placeholder: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.branchBackground)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.lineSeparator, lineWidth: 1) // Apply a white stroke with desired lineWidth
                )
            NOSWUITextEditor(text: $text, placeholder: $placeholder)
                .padding(5)
        }
    }
}
