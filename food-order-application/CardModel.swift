//
//  CardModel.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//

import Foundation

class CartModel: NSObject {
    var itemId:String
    var itemName:String
    var itemQty:Int
    var itemPrice:Float
    var totalPrice:Float
    
    init(itemId:String,itemName:String,itemQty:Int,itemPrice:Float,totalPrice:Float) {
        self.itemId=itemId
        self.itemName=itemName
        self.itemQty=itemQty
        self.itemPrice=itemPrice
        self.totalPrice=totalPrice
    }
}
