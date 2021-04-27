//
//  CardDataList.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//

import Foundation

struct CartData {
    static var cartList:[CartModel] = []
}

func addNewItem(item:CartModel){
    CartData.cartList.append(item)
}

func removeCart(){
    CartData.cartList=[]
}
