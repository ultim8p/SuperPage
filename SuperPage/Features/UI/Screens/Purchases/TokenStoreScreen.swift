//
//  TokenStoreScreen.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/27/24.
//

import SwiftUI
import StoreKit

struct TokenProductView: View {
    
    @EnvironmentObject var store: StoreKitManager
    
    let selected: Bool
    
    let product: StoreProduct
    
    let actionHandler: (() -> Void)?
    
    var body: some View {
        CompButton {
            actionHandler?()
        } label: {
            VStack(spacing: 0) {
                ZStack {
                    AppIcon.hockeyPuck.image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 50, height: 50)
                    if product == .tokensBulk {
                        AppIcon.hockeyPuck.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .padding(.top, 15)
                        AppIcon.hockeyPuck.image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50, height: 50)
                            .padding(.top, 30)
                    }
                }
                .frame(height: 70)
                Text(product.tokenProductName)
                    .font(.system(.largeTitle, weight: .black))
                    .lineLimit(2)
                
                Text("Million Tokens")
                    .font(.system(.body, weight: .light))
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .lineSpacing(-2)
                    .padding(.top, 0)
                
                Text("\(store.productBinding(for: product).wrappedValue?.displayPrice ?? "-")" )
                    .font(.system(.body, weight: .bold))
                    .padding(.top, 5)
            }
        }
        .frame(width: 120, height: 200)
        .compBackground(color: selected ? .primary : .clear, shape: .roundedRectangle(.soft))
        .compBorder(color: .contrastSecondary, width: .regular, shape: .roundedRectangle(.soft))
        .shadow(radius: 5)
        .contentShape(Rectangle())
    }
}

struct TokenStoreScreen: View {
    
    @EnvironmentObject var store: StoreKitManager
    
    @EnvironmentObject var navManager: NavigationManager
    
    @State var selectedProduct: StoreProduct = .tokensBasic
    
    var body: some View {
        ZStack {
            AppColor.main.color
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    CompButton {
                        navManager.sheetTokenStore = false
                    } label: {
                        CompIcon(size: .medium, iconSize: .xSmall, icon: .xmark, color: .contrast, weight: .black)
                    }
                    .padding()
                }
                Spacer()
            }
            
            VStack(spacing: 0) {
                
                Text("Get More Tokens")
                    .font(.system(.largeTitle, weight: .black))
                    .multilineTextAlignment(.center)
                    .padding()
                Spacer()
                Text("1 token ≈ 1 english word")
                    .font(.system(.body, weight: .bold))
                    .padding(.bottom, 10)
                HStack(spacing: 0) {
                    TokenProductView(
                        selected: selectedProduct == .tokensBasic,
                        product: .tokensBasic,
                        actionHandler: {
                            selectedProduct = .tokensBasic
                        }
                    )
                    .padding(.trailing, 20)
                    TokenProductView(
                        selected: selectedProduct == .tokensBulk,
                        product: .tokensBulk,
                        actionHandler: {
                            selectedProduct = .tokensBulk
                        }
                    )
                }
                Spacer()
                // Disclaimer
                Text("Purchased tokens never expire and are additional to your monthly subscription.")
                    .multilineTextAlignment(.center)
                    .lineLimit(4)
                    .font(.system(.caption, weight: .light))
                    .padding(.leading, 40).padding(.trailing, 40).padding(.bottom, 5)
                // Button
                CompButton {
                    
                } label: {
                    Text("Purchase Tokens")
                        .compText(fontStyle: .title3)
                        .componentMainButton()
                }
                .padding(.leading).padding(.trailing).padding(.bottom)
            }
        }
#if os(macOS)
        .frame(width: 600, height: 500)
#endif
    }
}

#Preview {
    TokenStoreScreen()
        .environmentObject(StoreKitManager.mock)
        .environmentObject(NavigationManager.mock)
}
