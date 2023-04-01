//
//  SettingsInteractor.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/30/23.
//

import Foundation
import SwiftUI

class SettingsInteractor: ObservableObject {
    
    let repo: SettingsRepo
    
    @Published var settingsUsage: SettingsUsage = SettingsUsage()
    
    @ObservedObject var env: EnvironmentInteractor
    
    init(repo: SettingsRepo) {
        self.repo = repo
        env = EnvironmentInteractor.mock
    }
    
    func inject(env: EnvironmentInteractor) {
        self.env = env
    }
}

extension SettingsInteractor {
    
    static var mock: SettingsInteractor {
        return SettingsInteractor(repo: SettingsRepo())
    }
}
