//
//  CategoryModel.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-28.
//

import UIKit

class CategoryModel: NSObject {
    var categoryId:String
    var categoryName:String
    
    init(categoryId:String,categoryName:String) {
        self.categoryId=categoryId
        self.categoryName=categoryName
    }
}
