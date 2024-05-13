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
            VStack {
                Spacer()
                CompButton {
                    navManager.sheetUpgrade = true
                } label: {
                    VStack(spacing: 0) {
                        Text("Get SuperPage Plus")
                            .multilineTextAlignment(.center)
                            .padding()
                            .compText(fontStyle: .title3, fontWeight: .bold)
                            .componentMainButton()
                    }
                }
                .padding(.leading).padding(.trailing).padding(.bottom, 5)
                Spacer()
            }
        }
        
        .frame(height: 65.0)
    }
}

#Preview {
    HomeUpgradeView()
        .environmentObject(NavigationManager.mock)
}
