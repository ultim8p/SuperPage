//
//  EmojiList.swift
//  SuperPage
//
//  Created by Guerson Perez on 9/26/23.
//

import Foundation

struct EmojiList: Codable {
    
    var categories: [EmojiCategory]?
}

struct EmojiCategory: Codable, Identifiable {
    
    var id = UUID()
    
    var type: EmojiCategoryType?
    
    var emojs: [String]?
}

enum EmojiCategoryType: String, Codable {
    
    case smileys
    case people
    case animals
    case food
    case activity
    case travel
    case objects
    
    var emojis: [String] {
        switch self {
        case .smileys:
            return ["😀", "😃", "😄", "😁", "😆", "😅", "😂", "🤣", "😊", "😇", "🙃", "😉", "😌", "😍", "🥰", "😘", "😗", "😙", "😚", "😋", "😛", "😝", "😜", "🤪", "🤨", "🧐", "🤓", "😎", "🥸", "🤩", "🥳", "😏", "😒", "😞", "😔", "😟", "😕", "🙁", "☹️", "😢", "😭", "😤", "😠", "😡", "🤬", "🥺"]
        case .people:
            return ["👶", "👦", "👧", "👨", "👩", "👴", "👵", "🧑", "👱‍♂️", "👱‍♀️", "👮‍♂️", "👮‍♀️", "👷‍♂️", "👷‍♀️", "💂‍♂️", "💂‍♀️", "🕵️‍♂️", "🕵️‍♀️", "👩‍⚕️", "👨‍⚕️", "👩‍🌾", "👨‍🌾", "👩‍🍳", "👨‍🍳", "👩‍🎓", "👨‍🎓", "👩‍🎤", "👨‍🎤", "👩‍🏫", "👨‍🏫", "👩‍🏭", "👨‍🏭", "👩‍💻", "👨‍💻", "👩‍💼", "👨‍💼", "👩‍🔧", "👨‍🔧", "👩‍🔬", "👨‍🔬", "👩‍🎨", "👨‍🎨", "👩‍🚒", "👨‍🚒", "👩‍✈️", "👨‍✈️", "👩‍🚀", "👨‍🚀", "👩‍⚖️", "👨‍⚖️"]

        case .animals:
            return ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐻‍❄️", "🐨", "🐯", "🦁", "🐮", "🐷", "🐽", "🐸", "🐵", "🦄", "🦓", "🦌", "🦒", "🦘", "🐘", "🦏", "🦛", "🐪", "🐫", "🦍", "🦧", "🐃"]
        case .food:
            return ["🍏", "🍎", "🍐", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🍈", "🍒", "🍑", "🍍", "🥭", "🥥", "🍆", "🍅", "🍄", "🥕", "🌽", "🌶", "🫑", "🥒", "🥬", "🥦", "🧄", "🧅", "🥔", "🍠", "🥐"]
        case .activity:
            return ["⚽️", "🏀", "🏈", "⚾️", "🥎", "🎾", "🏐", "🏉", "🎱", "🪀", "🏓", "🏸", "🏒", "🏑", "🥍", "🏏", "🪃", "🥅", "🀄️", "🎯", "🎲", "🎭", "🎨", "🎬", "🎤", "🎧", "🎼", "🎹", "🥁", "🎷"]
        case .travel:
            return ["🚗", "🚕", "🚙", "🚌", "🚎", "🏎", "🚓", "🚑", "🚒", "🚐", "🚚", "🚛", "🚜", "🏍", "🛵", "🪖", "🚲", "🛴", "🚏", "🛣", "🛤", "🛢", "🛳", "⛴", "🛥", "🚢", "✈️", "🛩", "🛫", "🛬", "🪂", "🛰"]
        case .objects:
            return ["🕶", "👓", "🥽", "🥼", "🦺", "👔", "👕", "👖", "🧣", "🧤", "🧥", "🧦", "👗", "👘", "🥻", "🩱", "🩲", "🩳", "👙", "👚", "👛", "👜", "🛍", "🎒", "👒", "🎩", "🧢", "⛑", "💄", "💍", "🌂"]
        }
    }
}

let fullEmojiList = EmojiList(
    
    categories: [
        EmojiCategory(type: .smileys, emojs: EmojiCategoryType.smileys.emojis),
        EmojiCategory(type: .people, emojs: EmojiCategoryType.people.emojis),
        EmojiCategory(type: .animals, emojs: EmojiCategoryType.animals.emojis),
        EmojiCategory(type: .food, emojs: EmojiCategoryType.food.emojis),
        EmojiCategory(type: .activity, emojs: EmojiCategoryType.activity.emojis),
        EmojiCategory(type: .travel, emojs: EmojiCategoryType.travel.emojis),
        EmojiCategory(type: .objects, emojs: EmojiCategoryType.objects.emojis)
    ]
)
