//
//  SystemImage.swift
//  Atlet
//
//  Created by Guerson Perez on 2/6/23.
//

import Foundation
import SwiftUI

enum AppIcon: String {
    case chevronLeft = "chevron.left"
    case heartFill = "heart.fill"
    case squareOnSquareSquareshapeControlhandles = "square.on.square.squareshape.controlhandles"
    case xmark = "xmark"
    case doc = "doc"
    case docPlaintext = "doc.plaintext"
    case docAppend = "doc.append"
    case docText = "doc.text"
    case docBadgePlus = "doc.badge.plus"
    case docBadgeEllipsis = "doc.badge.ellipsis"
    case textMagnifyingGlass = "text.magnifyingglass"
    case gearShape = "gearshape"
    case paperplane = "paperplane"
    case paperplaneFill = "paperplane.fill"
    case folderBadgePlus = "folder.badge.plus"
    case folder = "folder"
    case listBullet = "list.bullet"
    case chevronRight = "chevron.right"
    case chevronCompactRight = "chevron.compact.right"
    case arrowTurnDownRight = "arrow.turn.down.right"
    case squareAndPencil = "square.and.pencil"
    case rectangleAndPencilAndEllipsis = "rectangle.and.pencil.and.ellipsis"
    case paperclipBadgeEllipsis = "paperclip.badge.ellipsis"
    case paperclip = "paperclip"
    case checkmarkSquare = "checkmark.square"
    case square = "square"
    case exclamationMarkOctagon = "exclamationmark.octagon"
    case faceDashedFill = "face.dashed.fill"
    case lockiCloud = "lock.icloud"
    case checkmarkiCloud = "checkmark.icloud"
    case gymBag = "gym.bag"
    case macbook = "macbook"
    case ipadLandscape = "ipad.landscape"
    case iphone = "iphone"
    case circleDashedInsetFilled = "circle.dashed.inset.filled"
    case icloudSlash = "icloud.slash"
    case hockeyPuck = "hockey.puck"
    
    var image: Image {
        Image(systemName: rawValue)
    }
}
enum SystemImage: String {
    
    case chevronLeft = "chevron.left"
    
    case heartFill = "heart.fill"
    
    case squareOnSquareSquareshapeControlhandles = "square.on.square.squareshape.controlhandles"
    
    case xmark = "xmark"
    
    case doc = "doc"
    case docPlaintext = "doc.plaintext"
    case docAppend = "doc.append"
    case docText = "doc.text"
    case docBadgeEllipsis = "doc.badge.ellipsis"
    
    case textMagnifyingGlass = "text.magnifyingglass"
    
    case gearShape = "gearshape"
    
    case paperplane = "paperplane"
    case paperplaneFill = "paperplane.fill"
    
    case folderBadgePlus = "folder.badge.plus"
    
    case folder = "folder"
    
    case listBullet = "list.bullet"
    
    case chevronRight = "chevron.right"
    case chevronCompactRight = "chevron.compact.right"
    
    case arrowTurnDownRight = "arrow.turn.down.right"
    
    case squareAndPencil = "square.and.pencil"
    case rectangleAndPencilAndEllipsis = "rectangle.and.pencil.and.ellipsis"
    
    case paperclipBadgeEllipsis = "paperclip.badge.ellipsis"
    case paperclip = "paperclip"
    
    case checkmarkSquare = "checkmark.square"
    case square = "square"
    
    case exclamationMarkOctagon = "exclamationmark.octagon"
    
    case faceDashedFill = "face.dashed.fill"
    
    case lockiCloud = "lock.icloud"
    
    case checkmarkiCloud = "checkmark.icloud"
}
