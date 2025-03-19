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
        orderStatusColor: "We are yet to assign someone to pickup your laundry and if you have any issuues please contact us via the support tab",
        orderStatusMessage: "Pending",
        orderPickupLocation: "Accra",
        orderAmount: "¢211",
        orderDate: "Apr 4",
        orderDeliveryDate: "Pending",
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
        orderDeliveryDate: "Pending",
        orderUserId: "3"
    )
]
