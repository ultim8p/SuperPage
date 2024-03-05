//
//  AnyShape.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/21/24.
//

import SwiftUI

struct AnyShape: Shape {
    private let path: (CGRect) -> Path

    init<S: Shape>(_ wrapped: S) {
        self.path = { rect in
            let path = wrapped.path(in: rect)
            return path
        }
    }

    func path(in rect: CGRect) -> Path {
        return self.path(rect)
    }
}
