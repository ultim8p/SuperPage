//
//  APIResponseError.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation
import NoAPI

struct APIResponseError: DecodableError {
    
    var message: String?
}
