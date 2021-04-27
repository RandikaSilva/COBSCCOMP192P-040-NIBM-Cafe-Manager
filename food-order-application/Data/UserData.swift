//
//  UserData.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//

import Foundation

var firebaseUserData=FirebaseService()

struct UserData {
    static var emailAddress:String = ""
    static var mobileNumber:String = ""
}

func setUserData(user:UserModel){
    UserData.emailAddress=user.emailAddress
    UserData.mobileNumber=user.mobileNumber
}
