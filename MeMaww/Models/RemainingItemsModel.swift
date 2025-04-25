//
//  NotificationModel.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 12/3/24.
//


import Foundation

struct RemainingItemsModel: Identifiable, Codable {
    var id = UUID()
    var remaining_items_body: String
    var remaining_items_date: String
    //var timestamp: Date
}
