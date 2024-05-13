//
//  CompSeparator.swift
//  SuperPage
//
//  Created by Guerson Perez on 28/03/24.
//

import SwiftUI

struct CompSeparator: View {
    
    var body: some View {
        AppColor.contrastSecondary.color
            .frame(height: 1)
            .padding(.leading).padding(.trailing)
    }
}

#Preview {
    CompSeparator()
}
