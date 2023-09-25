//
//  ListResponse.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/29/23.
//

import Foundation

struct ListResponse<T: Codable>: Codable {
    
    var items: [T]?
    
    init(items: [T]? = nil) {
        self.items = items
    }
}
