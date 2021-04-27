//
//  OrderModel.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//


import UIKit


import UIKit

class OrderModel: NSObject {
    var orderId:Int = 0
    var orderStatus:String="Pending"
    
    init(orderId:Int,orderStatus:String) {
        self.orderId=orderId
        self.orderStatus=orderStatus
    }
}
