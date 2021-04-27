//
//  ItemData.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-28.
//

import Foundation

struct ItemData {
    static var itemList:[ItemModels] = []
}

func populateItemList(items:[ItemModels]){
    ItemData.itemList=items
}
