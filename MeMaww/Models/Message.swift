//
//  Message.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/22/24.
//

import Foundation

struct Message: Identifiable, Codable {
    var id: String
    var text: String
    var received: Bool
    var timestamp: String
    //var timestamp: Date
}
