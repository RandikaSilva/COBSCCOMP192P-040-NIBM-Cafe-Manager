//
//  OrderData.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//



import Foundation

struct OrderData {
    static var orderId:Int = 1
    static var orderList:[OrderModel] = []{
        didSet{
            orderId+=1
        }
    }
}

func addNewOrder(order:OrderModel){
    OrderData.orderList.append(order)
}
