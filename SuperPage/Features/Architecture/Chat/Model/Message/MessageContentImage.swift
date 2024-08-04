//
//  MessageContentImage.swift
//  SuperPage
//
//  Created by Guerson Perez on 2/7/24.
//

import Foundation

struct MessageContentImage: Codable, Equatable {
    
    var bucket: String?
    
    var size: Int?
    
    var width: Double?
    
    var height: Double?
    
    var format: String?
    
    var identifier: String?
}
