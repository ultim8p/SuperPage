//
//  SuperTextField.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/9/24.
//

import SwiftUI

struct SuperTextField: View {
    
    let placeholder: String
    @Binding var text: String
    let placeholderColor: Color = .spDefaultText
    
    var editing: Bool = false
    
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ZStack(alignment: .leading) {
            TextField("", text: $text)
                .focused($isFocused)
                .textFieldStyle(.plain)
                .padding(10)
                .font(.headline)
                .foregroundStyle(Color.white) // Text input color
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color("branchBackground")) // Replace with your actual color
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color("lineSeparator"), lineWidth: 1) // Replace with your actual color
                        )
                )
                .padding()
                .onAppear {
                    if editing {
                        DispatchQueue.main.async {
                            self.isFocused = editing
                        }
                    }
                }
        }
    }
}
