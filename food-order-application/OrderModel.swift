//
//  OrderModel.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//


import UIKit


import UIKit

class OrderModel: NSObject {
    var orderId:String
    var userEmailAddress:String
    var items:[CartModel]
    var total:Float
    var status:Int
    
    init(orderId:String,userEmailAddress:String,items:[CartModel],total:Float,status:Int) {
        self.orderId=orderId
        self.userEmailAddress=userEmailAddress
        self.items=items
        self.total=total
        self.status=status
    }
}

class StatusData: NSObject {
    var orderId:String=""
    var status:Int=0
    var isRecieved:Bool=false
    
    var asDictionary : [String:Any] {
        let mirror = Mirror(reflecting: self)
        let dict = Dictionary(uniqueKeysWithValues: mirror.children.lazy.map({ (label:String?, value:Any) -> (String, Any)? in
          guard let label = label else { return nil }
          return (label, value)
        }).compactMap { $0 })
        return dict
      }
}
