//
//  FieldNameTextField.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/31/23.
//

import Foundation
import SwiftUI

struct FieldNameTextField: View {
    
    @Binding var text: String
    
    var placeholder: String
    
    var submitHandler: (() -> Void)?
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .font(.title)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .foregroundColor(Color(CGColor(gray: 0.1, alpha: 1.0)))
            )
            .foregroundColor(Color.white)
            .onSubmit {
                submitHandler?()
            }
    }
}

extension FieldNameTextField {
    
    func onSubmitName(handler: (() -> Void)?) -> some View {
        FieldNameTextField(
            text: $text, placeholder: placeholder, submitHandler: handler)
    }
}

struct FieldNameTextField_Previews: PreviewProvider {
    
    static var previews: some View {
        FieldNameTextField(text: .constant(""), placeholder: "Type...")
    }
}
