//
//  OrderData.swift
//  MeMaww
//
//  Created by Dankyi Anno Kwaku on 4/20/24.
//

import SwiftUI


let orderData: [OrderModel] = [
    OrderModel(
        orderId: "1111",
        orderAllItemsQuantity: "10",
        orderStatus: 0,
        orderStatusColor: "ColorMeMawwBlueLight",
        orderStatusMessage: "Pending",
        orderPickupLocation: "Accra",
        orderAmount: "¢211",
        orderDate: "Apr 4",
        orderUserId: "3"
    ),
    OrderModel(
        orderId: "543",
        orderAllItemsQuantity: "9",
        orderStatus: 0,
        orderStatusColor: "ColorMeMawwBlueLight",
        orderStatusMessage: "Completed",
        orderPickupLocation: "Airport Residential",
        orderAmount: "¢391",
        orderDate: "Mar 8",
        orderUserId: "3"
    )
]
