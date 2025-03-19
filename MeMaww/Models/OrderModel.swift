//
//  OrderModel.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/20/24.
//

import SwiftUI

struct OrderModel: Identifiable {
    var id = UUID()
    var orderId: String
    var orderAllItemsQuantity: String
    var orderStatus: Int
    var orderStatusColor: String
    var orderStatusMessage: String
    var orderPickupLocation: String
    var orderAmount: String
    var orderDate: String
    var orderDeliveryDate: String
    var orderUserId: String
}

