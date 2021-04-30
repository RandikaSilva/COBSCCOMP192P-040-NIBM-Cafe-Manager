//
//  UserModel.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//

import UIKit

import UIKit

class UserModel: NSObject {
    var uuid:String
    var emailAddress:String
    var mobileNumber:String
    var password:String
    var type:Int
    
    init(uuid:String="",emailAddress:String="",mobileNumber:String="",password:String="",type:Int=0) {
        self.uuid=uuid
        self.emailAddress=emailAddress
        self.mobileNumber=mobileNumber
        self.password=password
        self.type=type
    }
}
