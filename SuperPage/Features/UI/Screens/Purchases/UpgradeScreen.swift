//
//  UpgradeScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/21/24.
//

import SwiftUI
import StoreKit

struct UpgradeScreen: View {
    // This variable could be used to control the display of the paywall screen
    
    @EnvironmentObject var navManager: NavigationManager
    
    @EnvironmentObject var store: StoreKitManager
    
    var body: some View {
        ZStack {
            AppColor.main.color.ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    CompButton {
                        navManager.sheetUpgrade = false
                    } label: {
                        CompIcon(size: .medium, iconSize: .xSmall, icon: .xmark, color: .contrast, weight: .black)
                    }
                    .padding()
                }
                Spacer()
            }
            VStack {
                HStack {
                    Text("Upgrade to\nSuperPage Plus")
                        .compText(fontStyle: .largeTitle, fontWeight: .black)
                        .multilineTextAlignment(.center)
                        .padding()
                }
                
                if let product = store.productBinding(for: "superpage.plus.monthly").wrappedValue {
                    Spacer()
                    OfferView()
                    Spacer()
                    VStack(spacing: 0) {
                        CompButton {
                            print("Purchase product")
                        } label: {
                            Text(product.displayPurchaseText ?? "Get Plus")
                                .compText(fontStyle: .title3, fontWeight: .bold)
                                .compFrame(style: .rectangle(height: .regular))
                                .compBackground(color: .primary, shape: .roundedRectangle(.soft))
                        }
                        if let displayPriceText = product.displaySubscriptionPriceText {
                            Text(displayPriceText)
                                .compText(fontStyle: .caption, fontWeight: .light)
                                .padding(.top, 5)
                        }
                    }
                    .padding()
                } else {
                    Spacer()
                    VStack {
                        CompIcon(size: .large, iconSize: .large, icon: .icloudSlash, color: .highlight, weight: .regular)
                        Text("Unable to load products, please verify your internet connection & try again.")
                            .multilineTextAlignment(.center)
                            .compText(fontStyle: .body, fontWeight: .light)
                            .padding(.leading, 60).padding(.trailing, 60)
                    }
                    Spacer()
                    CompButton {
                        loadProducts()
                    } label: {
                        Text("Retry")
                            .compText(fontStyle: .title3, fontWeight: .bold)
                            .componentMainButton()
                    }
                    .padding()
                }
            
            }
        }
        #if os(macOS)
        .frame(width: 600, height: 700)
        #endif
        .onAppear {
            loadProducts()
        }
    }
}

private extension UpgradeScreen {
    
    func loadProducts() {
        Task {
            await store.fetchProducts()
        }
    }
}

private extension Product {
    
    func describe(subscriptionPeriod: SubscriptionPeriod) -> String {
        switch subscriptionPeriod.unit {
        case .day:
            return "day"
        case .week:
            return "week"
        case .month:
            return "month"
        case .year:
            return "year"
        @unknown default:
            return "time"
        }
    }
    
    var displayPurchaseText: String? {
        if let offer = subscription?.introductoryOffer, offer.type == .introductory {
            let period = offer.period
            return "Try \(period.value) \(period.unit) Free"
        }
        return nil
    }
    
    var displaySubscriptionPriceText: String? {
        if let subscriptionPeriod = subscription?.subscriptionPeriod {
            let price = displayPrice
            let interval = describe(subscriptionPeriod: subscriptionPeriod)
            return "After \(price) per \(interval)"
        }
        
        return nil
    }
}

//private extension

// Preview for SwiftUI Canvas
struct PaywallView_Previews: PreviewProvider {
    static var previews: some View {
        UpgradeScreen()
            .environmentObject(StoreKitManager.mock)
            .environmentObject(NavigationManager.mock)
    }
}

private struct OfferView: View {
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    CompIcon(size: .medium, iconSize: .medium, icon: .hockeyPuck, color: .highlight, weight: .regular)
                    Spacer()
                }
                Text("One million tokens per month to use with any bot.")
                    .compText(fontStyle: .body)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    CompIcon(size: .medium, iconSize: .medium, icon: .lockiCloud, color: .highlight, weight: .regular)
                    Spacer()
                }
                Text("Unlimited cloud storage, secure & private.")
                    .compText(numberOfLines: 2, fontStyle: .body)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                HStack(alignment: .bottom, spacing: 5) {
                    AppIcon.macbook.image
                        .font(.system(size: 40.0, weight: .regular))
                    AppIcon.ipadLandscape.image
                        .font(.system(size: 30.0, weight: .regular))
                    AppIcon.iphone.image
                        .font(.system(size: 20.0, weight: .regular))
                    Spacer()
                }
                .foregroundStyle(AppColor.highlight.color)
                Text("Sync across your devices.")
                    .compText(fontStyle: .body)
            }
        }
        .padding(.leading, 80)
        .padding(.trailing, 80)
    }
}
