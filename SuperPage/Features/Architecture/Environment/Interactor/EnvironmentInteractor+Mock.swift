//
//  EnvironmentInteractor+Mock.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import SwiftUI

extension EnvironmentInteractor {
    
    static var mock: EnvironmentInteractor {
        return EnvironmentInteractor(state: EnvironmentState())
    }
}
