//
//  CategoryData.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-28.
//

import Foundation

struct CategoryData {
    static var categoryList:[CategoryModel] = []
}

func populateCategoryList(categories:[CategoryModel]){
    CategoryData.categoryList=categories
}
