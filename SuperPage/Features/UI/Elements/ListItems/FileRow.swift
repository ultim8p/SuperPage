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
    let folder: Bool
    let isExpanded: Bool
    let loading: Bool
    let hasError: Bool
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        let leadingSpace: CGFloat = folder ? 0.0 : 24
        
        HStack {
            let imageName: String = hasError ?
            SystemImage.exclamationMarkOctagon.rawValue :
            folder ?
            SystemImage.folder.rawValue :
            SystemImage.docText.rawValue
            
            let font: Font = .body
            let darkMode = colorScheme == .dark
            let color: Color = darkMode ?
            folder ? .white : Color(CGColor(gray: 0.7, alpha: 1)) :
            folder ? .black : Color(red: 0.0, green: 0.0, blue: 0.0)
            if folder {
                Image(systemName: SystemImage.chevronRight.rawValue)
                    .rotationEffect(Angle(degrees: isExpanded ? 90.0 : 0.0))
            }
            let iconColor: Color = hasError ? .red : .cyan
            Image(systemName: imageName)
                .foregroundColor(iconColor)
                .font(font)
            Text(name)
                .font(font)
                .foregroundColor(color)
            Spacer()
            if loading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    .frame(width: 20.0, height: 20.0)
                #if os(macOS)
                    .scaleEffect(0.5)
                #endif
            }
        }
        .padding(.leading, leadingSpace)
    }
    
}

struct FileRow_Previews: PreviewProvider {
                            
    static var previews: some View {
        FileRow(name: "Test File", folder: false, isExpanded: true, loading: false, hasError: false)
    }
}
