//
//  FoodItemModel.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//

import Foundation

class ItemModel: NSObject {
    var foodId:Int
    var foodName:String
    var foodDescription:String
    var foodPrice:Float
    var foodDiscount:Float
    var foodPhoto:String
    
    init(foodId:Int,foodName:String,foodDescription:String,foodPrice:Float,foodPhoto:String,foodDiscount:Float) {
        self.foodId=foodId
        self.foodName=foodName
        self.foodDescription=foodDescription
        self.foodPrice=foodPrice
        self.foodDiscount=foodDiscount
        self.foodPhoto=foodPhoto
    }
}
