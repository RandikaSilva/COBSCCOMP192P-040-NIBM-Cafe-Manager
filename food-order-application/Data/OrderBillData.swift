//
//  OrderBillData.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-29.
//

import Foundation

struct OrderBillData {
    static var billOrderList:[OrderModel] = []
}

func populateBillOrderList(orders:[OrderModel]){
    OrderBillData.billOrderList=orders
}
