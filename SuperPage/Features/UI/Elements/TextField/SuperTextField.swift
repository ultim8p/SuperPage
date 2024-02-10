//
//  SuperTextField.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/9/24.
//

import SwiftUI

struct SuperTextField: View {
    
    @Binding var text: String
    
    var body: some View {
        ZStack {
            TextField("", text: $text)
                .textFieldStyle(.plain)
                .padding(10)
                .font(.headline)
                .foregroundStyle(Color.white)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.branchBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.lineSeparator, lineWidth: 1)
                        )
                )
                .padding()
        }
    }
}
