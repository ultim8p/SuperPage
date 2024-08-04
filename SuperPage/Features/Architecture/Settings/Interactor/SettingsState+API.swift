//
//  SettingsState+API.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/30/23.
//

import Foundation

extension SettingsState {
    
    // MARK: - GET
    
    func reloadSetttings() {
        Task {
            do {
                let settings = try await repo.getSettingsMe(env: envState)
                self.settingsUsage = settings
            }
            catch {
                print("GET SETTINGS ERROR: \(error)")
            }
        }
    }
}
