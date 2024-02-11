//
//  FileRow.swift
//  SuperPage
//
//  Created by Guerson Perez on 4/3/23.
//

import Foundation
import SwiftUI

struct FileRow: View {
    
    let name: String
    let isExpanded: Bool
    let loading: Bool
    let hasError: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        ZStack {
            HStack {
                Image(systemName: SystemImage.chevronRight.rawValue)
                    .font(.system(size: 10, weight: .bold))
                    .rotationEffect(Angle(degrees: isExpanded ? 90.0 : 0.0))
                Spacer()
            }
            .padding(.leading, 10)
            
            HStack(spacing: 0) {
                let imageName: String = hasError ?
                SystemImage.exclamationMarkOctagon.rawValue : SystemImage.folder.rawValue
                
                let font: Font = .system(size: 14, weight: .regular)
                let color: Color = .spDefaultText
                
                let iconColor: Color = hasError ? .red : .cyan
                Image(systemName: imageName)
                    .foregroundColor(iconColor)
                    .font(font)
                    .frame(width: 22.0, height: 22.0)
                Text(name)
                    .font(font)
                    .foregroundStyle(color)
                    .padding(.leading, 2)
                Spacer()
                if loading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .frame(width: 20.0, height: 20.0)
                    #if os(macOS)
                        .scaleEffect(0.4)
                    #endif
                }
            }
            .padding(.leading, 22)
            .padding(.trailing, 12)
        }
        .padding(.leading, 8)
    }
    
}

struct FileRow_Previews: PreviewProvider {
                            
    static var previews: some View {
        FileRow(name: "Test File", isExpanded: true, loading: false, hasError: false)
    }
}
