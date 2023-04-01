//
//  User.swift
//  SuperPage
//
//  Created by Guerson Perez on 3/26/23.
//

import Foundation

struct User: Codable, Identifiable {
    
    var id: String { _id ?? UUID().uuidString }
    
    var _id: String?
    
    var dateCreated: Date?
    
    var dateUpdated: Date?
    
    var username: String?
}
