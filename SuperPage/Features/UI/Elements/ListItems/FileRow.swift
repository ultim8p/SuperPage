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
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        HStack {
            let leadingSpace: CGFloat = folder ? 0.0 : 24
            HStack {
                let imageName: String = folder ?  SystemImage.folder.rawValue : SystemImage.docText.rawValue
                let font: Font = .body
                let darkMode = colorScheme == .dark
                let color: Color = darkMode ?
                folder ? .white : Color(CGColor(gray: 0.7, alpha: 1)) :
                folder ? .black : Color(red: 0.0, green: 0.0, blue: 0.0)
                if folder {
                    Image(systemName: SystemImage.chevronRight.rawValue)
                        .rotationEffect(Angle(degrees: isExpanded ? 90.0 : 0.0))
                }
                Image(systemName: imageName)
                    .foregroundColor(.cyan)
                    .font(font)
                Text(name)
                    .font(font)
                    .foregroundColor(color)
                Spacer()
            }
            .padding(.leading, leadingSpace)
        }
    }
}
