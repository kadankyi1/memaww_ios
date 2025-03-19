//
//  NotificationModel.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 12/3/24.
//


import Foundation

struct NotificationModel: Identifiable, Codable {
    var id = UUID()
    var notification_title: String
    var notification_body: String
    var notification_date: String
    //var timestamp: Date
}
