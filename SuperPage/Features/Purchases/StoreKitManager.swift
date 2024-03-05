//
//  StoreKitManager.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/21/24.
//

import SwiftUI
import StoreKit
import Combine

enum StoreProduct: String, CaseIterable {
    
    case plusMonthly = "superpage.plus.monthly"
    
    case tokensBasic = "superpage.tokensbasic"
    
    case tokensBulk = "superpage.tokensbulk"
    
    static var rawValues: [String] {
        allCases.map({ $0.rawValue })
    }
    
    var tokenProductName: String {
        switch self {
        case .tokensBasic:
            return "3"
        case .tokensBulk:
            return "15"
        default:
            return ""
        }
    }
}

@MainActor final class StoreKitManager: ObservableObject {
    
    let identifiers: [String]
    
    @Published var products: [Product] = []
    
    @Published var fetchError: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    init(identifiers: [String]) {
        self.identifiers = identifiers
        $products
                    .sink { _ in
                        self.objectWillChange.send()
                    }
                    .store(in: &cancellables)
    }
    
    func fetchProducts() async {
        do {
            products = try await Product.products(for: identifiers)
        } catch {
            fetchError = error
        }
    }
}

// MARK: - Getting Products

extension StoreKitManager {
    
    func productBinding(for identifier: StoreProduct) -> Binding<Product?> {
        productBinding(for: identifier.rawValue)
    }
    
    func productBinding(for identifier: String) -> Binding<Product?> {
        Binding<Product?>(
            get: { [weak self] in
                self?.products.first { $0.id == identifier }
            },
            set: { [weak self] newValue in
                if let index = self?.products.firstIndex(where: { $0.id == identifier }) {
                    if let newValue = newValue {
                        self?.products[index] = newValue
                    } else {
                        self?.products.remove(at: index)
                    }
                } else if let newValue = newValue {
                    self?.products.append(newValue)
                }
            }
        )
    }
}

extension StoreKitManager {
    
    static var mock: StoreKitManager {
        StoreKitManager(identifiers: StoreProduct.rawValues)
    }
}
