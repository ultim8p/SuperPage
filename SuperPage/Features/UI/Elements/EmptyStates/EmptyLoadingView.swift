//
//  EmptyLoadingView.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/25/24.
//

import SwiftUI

struct EmptyLoadingView: View {
    
    var body: some View {
        ZStack {
            AppColor.main.color
                .ignoresSafeArea(.all)
        }
    }
}
