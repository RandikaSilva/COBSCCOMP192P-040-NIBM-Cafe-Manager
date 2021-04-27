//
//  UserModel.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//

import UIKit

import UIKit

class UserModel: NSObject {
    var emailAddress:String = ""
    var mobileNumber:String = ""
    
    init(emailAddress:String,mobileNumber:String) {
        self.emailAddress=emailAddress
        self.mobileNumber=mobileNumber
    }
}
