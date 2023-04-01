//
//  SettingsInteractor+API.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/30/23.
//

import Foundation

extension SettingsInteractor {
    
    // MARK: - GET
    
    func reloadSetttings() {
        Task {
            do {
                let settings = try await repo.getSettingsMe(env: env)
                self.settingsUsage = settings
            }
            catch {
                print("GET SETTINGS ERROR: \(error)")
            }
        }
    }
}
