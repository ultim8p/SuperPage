//
//  SettingsState.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/30/23.
//

import Foundation
import SwiftUI

@MainActor
class SettingsState: ObservableObject {
    
    // MARK: - Network
    
    let repo = SettingsRepo()
    
    // MARK: - Model State
    
    @Published var settingsUsage: SettingsUsage = SettingsUsage()
    
    // MARK: - App State
    
    @ObservedObject var envState: EnvironmentState
    
    init() {
        envState = EnvironmentState.mock
    }
    
    func inject(
        envState: EnvironmentState
    ) {
        self.envState = envState
    }
    
    func loadInitialState() {
        reloadSetttings()
    }
}

extension SettingsState {
    
    static var mock: SettingsState {
        SettingsState()
    }
}
