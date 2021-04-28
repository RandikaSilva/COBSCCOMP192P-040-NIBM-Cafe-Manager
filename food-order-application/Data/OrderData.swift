//
//  OrderData.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//



import Foundation

struct OrderData {
    static var orderList:[OrderModel] = []
}

func populateOrderList(orders:[OrderModel]){
    OrderData.orderList=orders
}
