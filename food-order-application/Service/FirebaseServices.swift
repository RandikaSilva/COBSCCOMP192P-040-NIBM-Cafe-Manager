//
//  FirebaseServices.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//

import UIKit;
import FirebaseAuth;
import FirebaseFirestore;

class FirebaseService: NSObject {
    let db = Firestore.firestore()
    
    func registerUser(emailAddress:String,mobileNumber:String,password:String,result: @escaping (_ authResult: Int?)->Void){
        Auth.auth().createUser(withEmail: emailAddress, password: password) { (response, error) in
            if error != nil {
                if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        case .emailAlreadyInUse:
                            result(2)
                        default:
                            result(0)
                    }
                }
            }else {
                result(1)
            }
        }
    }
    func loginUser(emailAddress:String,password:String,result: @escaping (_ authResult: Int?)->Void){
        Auth.auth().signIn(withEmail: emailAddress, password: password) { (response, error) in
            if error != nil {
                if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        case .invalidCredential:
                            result(3)
                        case .emailAlreadyInUse:
                            result(2)
                        default:
                            result(0)
                    }
                }
            }else {
                result(1)
            }
        }
    }
    
    
    
    func forgetPassword(emailAddress:String,result: @escaping (_ authResult: Int?)->Void){
        Auth.auth().sendPasswordReset(withEmail: emailAddress) { (error) in
            if error != nil {
                if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                    switch errCode {
                        case .invalidEmail:
                                result(2)
                        default:
                            result(0)
                    }
                }
            }else {
                result(1)
            }
        }
    }
    func addUserToFirestore(user:UserModel){
        var ref: DocumentReference? = nil
        ref = db.collection("users").addDocument(data: [
            "emailAddress": user.emailAddress,
            "mobileNumber": user.mobileNumber,
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
    }
    func fetchFoodsData(completion: @escaping (Bool)->()) {
        var foodList:[ItemModel]=[]
        
        db.collection("foods").getDocuments() { (querySnapshot, err) in
            if let err = err {
                completion(false)
            } else {
                for document in querySnapshot!.documents {
                    let foodIdData:Int=document.data()["foodId"] as! Int
                    let foodNameData:String=document.data()["foodName"] as! String
                    let foodDescriptionData:String=document.data()["foodDescription"] as! String
                    let foodPriceData:Float=document.data()["foodPrice"] as! Float
                    let foodPhotoData:String=document.data()["foodPhoto"] as! String
                    let foodDiscountData:Float=document.data()["foodDiscount"] as! Float
                    foodList.append(ItemModel(foodId: foodIdData, foodName: foodNameData, foodDescription: foodDescriptionData, foodPrice: foodPriceData, foodPhoto: foodPhotoData, foodDiscount:foodDiscountData))
                }
                populateFoodList(foods:foodList)
                completion(true)
            }
        }
    }
    func fetchUsersData(completion: @escaping (Bool)->()){
        db.collection("users").getDocuments() { (querySnapshot, err) in
            var isFound=false
            if let err = err {
                completion(false)
            } else {
                for document in querySnapshot!.documents {
                    if(document.data()["emailAddress"] as! String==UserData.emailAddress){
                        let emailAddress:String=document.data()["emailAddress"] as! String
                        let mobileNumber:String=document.data()["mobileNumber"] as! String
                        setUserData(user:UserModel(emailAddress: emailAddress, mobileNumber: mobileNumber))
                        isFound=true
                        break
                    }else{
                        isFound=false
                    }
                }
                if(isFound){
                    completion(true)
                }else{
                    completion(false)
                }
            }
        }
    }
}
