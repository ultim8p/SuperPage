//
//  SettingsScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation
import SwiftUI

struct RadialProgressBar: View {
    
    @EnvironmentObject var settingsInt: SettingsInteractor
    
    var body: some View {
        
        let purchasedTokens = CGFloat(settingsInt.settingsUsage.tokens?.purchased ?? 0)
        let tokensUsed = CGFloat(settingsInt.settingsUsage.usage?.tokens?.totalTokens ?? 0)
        let percentage = tokensUsed / purchasedTokens
        
        ZStack {
            Circle()
                .stroke(lineWidth: 20.0)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(1.0, max(0.0, percentage))))
                .stroke(style: StrokeStyle(lineWidth: 20.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(.green)
                .rotationEffect(Angle(degrees: -90.0))
                .animation(.easeIn(duration: 1.0), value: UUID())
            
            Text(String(format: "%.0f %%", percentage * 100.0))
                .font(.largeTitle)
                .bold()
        }
        .frame(width: 150.0, height: 150.0)
        .onAppear{
            settingsInt.reloadSetttings()
        }
    }
}

struct SettingsScreen: View {
    
    @EnvironmentObject var settingsInt: SettingsInteractor
    
    var body: some View {
        
        let purchasedTokens = settingsInt.settingsUsage.tokens?.purchased ?? 0
        let tokensUsed = settingsInt.settingsUsage.usage?.tokens?.totalTokens ?? 0
        
        VStack {
            Spacer()
            HStack {
                VStack(alignment: .leading) {
                    Text("Total tokens: \(purchasedTokens)")
                    Text("Used tokens: \(tokensUsed)")
                    Text("Available tokens: \(purchasedTokens - tokensUsed)")
                }
            }
            Spacer()
            RadialProgressBar()
            Spacer()
        }
    }
}


struct SettingsScreen_Previews: PreviewProvider {
                            
    static var previews: some View {
        SettingsScreen()
            .environmentObject(ChatInteractor.mock)
            .environmentObject(AuthenticationInteractor.mock)
            .environmentObject(UserInteractor.mock)
            .environmentObject(SettingsInteractor.mock)
    }
}
