//
//  HomeTokenStatsView.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/26/24.
//

import SwiftUI

extension Double {
    
    var numberFormattedString: String {
        let thousand = self / 1000
        let million = thousand / 1000
        let billion = million / 1000
        let trillion = billion / 1000

        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2

        if trillion >= 1.0 {
            return "\(formatter.string(from: NSNumber(value: trillion))!)t"
        } else if billion >= 1.0 {
            return "\(formatter.string(from: NSNumber(value: billion))!)b"
        } else if million >= 1.0 {
            return "\(formatter.string(from: NSNumber(value: million))!)m"
        } else if thousand >= 1.0 {
            return "\(formatter.string(from: NSNumber(value: thousand))!)k"
        } else {
            return "\(formatter.string(from: NSNumber(value: self))!)"
        }
    }
}

struct HomeTokenStatsView: View {
    
    // MARK: Navigation State
    
    @EnvironmentObject var navManager: NavigationManager
    
    // MARK: App State
    
    @EnvironmentObject var settingsState: SettingsState
    
    var body: some View {
        
        let purchasedTokens = Double(settingsState.settingsUsage.tokens?.purchased ?? 0)
        let tokensUsed = Double(settingsState.settingsUsage.usage?.tokens?.totalTokens ?? 0)
        let tokensLeft = max(0.0, Double(purchasedTokens - tokensUsed))
        let percentage = max(0.0, min(1.0, tokensLeft / 1_000_000))
        
        ZStack {
            
            VStack(spacing: 0.0) {
                Spacer()
                HStack{
                    VStack {
                        Spacer()
                        Text("\(tokensLeft.numberFormattedString) / 1 m")
                            .font(.system(size: 12, weight: .light))
                            .foregroundColor(AppColor.contrast.color) +
                        Text(" tokens left")
                            .font(.system(size: 10, weight: .light))
                            .foregroundColor(AppColor.contrast.color)
                    }
                    Spacer()
                    CompButton {
                        navManager.sheetTokenStore = true
                    } label: {
                        Text("Get Tokens")
                            .padding(.leading, 7).padding(.trailing, 7)
                            .padding(.top, 4).padding(.bottom, 4)
                            .compBackground(color: .primary, shape: .rounded)
                    }
                }
                .padding(.leading).padding(.trailing).padding(.bottom, 6)
                
                ProgressBarView(value: percentage)
                    .frame(height: 10.0)
                    .padding(.leading).padding(.trailing)
                    .padding(.bottom, 10)
            }
            .padding(.bottom, 5).padding(.top, 5)
        }
        .frame(height: 55.0)
    }
}

#Preview {
    HomeTokenStatsView()
        .environmentObject(AppState.mock)
}
