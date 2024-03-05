//
//  ProgressBarView.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/26/24.
//

import SwiftUI

struct ProgressBarView: View {
    
    var value: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(AppColor.contrastSecondary.color)
                    .cornerRadius(geometry.size.height * 0.5)
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(AppColor.secondary.color)
                    .cornerRadius(geometry.size.height * 0.5)
                    .animation(.linear, value: value)
            }
        }
    }
}

#Preview(body: {
    ProgressBarView(value: 0.2)
        .frame(height: 20.0)
})
