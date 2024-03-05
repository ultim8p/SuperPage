//
//  HomeUpgradeView.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/26/24.
//

import SwiftUI

struct HomeUpgradeView: View {
    
    @EnvironmentObject var navManager: NavigationManager
    
    var body: some View {
        ZStack {
            AppColor.mainSecondary.color
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .ignoresSafeArea()
            CompButton {
                navManager.sheetUpgrade = true
            } label: {
                VStack(spacing: 0) {
                    Text("Get SuperPage Plus")
                        .compText(fontStyle: .title3, fontWeight: .bold)
                        .componentMainButton()
                }
            }
        }
        .padding()
        .frame(height: 65.0)
    }
}

#Preview {
    HomeUpgradeView()
        .environmentObject(NavigationManager.mock)
}
