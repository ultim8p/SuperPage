//
//  CompButton.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/21/24.
//

import SwiftUI

struct CompButton<Label: View>: View {
    
    var action: () -> Void
    let label: () -> Label // Use ViewBuilder to allow passing custom views
    
    init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }
    
    var body: some View {
        Button(action: action, label: label)
            .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CompButton(action: {}) {
        CompIcon(size: .small, iconSize: .xSmall, icon: .arrowTurnDownRight, color: .highlight)
    }
}
