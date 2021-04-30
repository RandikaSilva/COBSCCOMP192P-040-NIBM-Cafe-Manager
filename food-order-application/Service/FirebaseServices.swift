//
//  FirebaseServices.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//

import UIKit;
import FirebaseAuth;
import FirebaseFirestore;
import FirebaseStorage;
import FirebaseDatabase;


class FirebaseService: NSObject {
    let db = Firestore.firestore()
    
    func registerUser(user:UserModel,result: @escaping (_ authResult: Int?)->Void){
        if (user.emailAddress != "" && user.mobileNumber != "" && user.password != ""){
            Auth.auth().createUser(withEmail: user.emailAddress, password: user.password) { (response, error) in
                if error != nil {
                    if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                            case .emailAlreadyInUse:
                                result(409)
                            default:
                                result(500)
                        }
                    }else{
                        result(500)
                    }
                }else {
                    FirebaseService().addUserToFirestore(user: user){
                        completion in
                        if (completion != nil){
                            user.uuid=(response?.user.uid)!
                            
                            UserDefaults.standard.set(true, forKey: "isLogged")
                            UserDefaults.standard.set(user.emailAddress, forKey: "emailAddress")
                            UserDefaults.standard.set(user.mobileNumber, forKey: "mobileNumber")
                            UserDefaults.standard.set(response?.user.uid, forKey: "uuid")
                            
                            UserData.emailAddress=user.emailAddress
                            UserData.mobileNumber=user.mobileNumber
                            UserData.uuid=(response?.user.uid)!
                            result(201)
                        }else{
                            result(500)
                        }
                    }
                }
            }
        }else{
            result(400)
        }
    }
    
    func addUserToFirestore(user:UserModel,result: @escaping (_ authResult: Int?)->Void){
        let ref = db.collection("users")
        ref.document(user.emailAddress).setData([
            "emailAddress": user.emailAddress,
            "mobileNumber": user.mobileNumber,
            "type":user.type
        ]) { err in
            if err != nil{
                result(500)
            } else {
                result(201)
            }
        }
    }
    
    func deleteCategory(categoryId:String)->Bool{
        do{
            db.collection("categories").document(categoryId).delete()
            return true
        } catch{
            return false
        }
    }
    
    
    func login(user:UserModel,result: @escaping (_ authResult: Int?)->Void){
        if (user.emailAddress != "" && user.password != ""){
            Auth.auth().signIn(withEmail: user.emailAddress, password: user.password) { (response, error) in
                print(error)
                if error != nil {
                    if let errCode = FirebaseAuth.AuthErrorCode(rawValue: error!._code) {
                        switch errCode {
                            case .wrongPassword:
                                result(401)
                            case .invalidCredential:
                                result(401)
                            case .emailAlreadyInUse:
                                result(409)
                            case .userNotFound:
                                result(401)
                            case .invalidEmail:
                                result(401)
                            default:
                                result(500)
                        }
                    }else{
                        result(500)
                    }
                }else {
                    UserDefaults.standard.set(true, forKey: "isLogged")
                    UserDefaults.standard.set(user.emailAddress, forKey: "emailAddress")
                    UserDefaults.standard.set(response?.user.uid, forKey: "uuid")
                    UserData.emailAddress=user.emailAddress
                    UserData.uuid=(response?.user.uid)!
                    
                    result(200)
                }
            }
        }else{
            result(400)
        }
    }
    
    
    func fetchUser(user:UserModel,completion: @escaping (Any)->()){
        let docRef = db.collection("users").document(user.emailAddress)
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let user = UserModel()
                user.emailAddress=document.get("emailAddress") as! String
                user.mobileNumber=document.get("mobileNumber") as! String
                user.type=document.get("type") as! Int
                
                UserDefaults.standard.set(user.mobileNumber, forKey: "mobileNumber")
                UserData.mobileNumber=user.mobileNumber
                completion(user)
            } else {
                completion(404)
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
    
    func getAllItems(completion: @escaping (Any)->()){
        var items:[ItemModels]=[]
        db.collection("items").getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                completion(500)
            }else{
                for document in querySnapshot!.documents {
                    let itemId=document.data()["itemId"] as! String
                    let itemName=document.data()["itemName"] as! String
                    let itemDescription=document.data()["itemDescription"] as! String
                    let itemThumbnail=document.data()["itemThumbnail"] as! String
                    let itemPrice=document.data()["itemPrice"] as! Float
                    let itemDiscount=document.data()["itemDiscount"] as! Float
                    let isAvailable=document.data()["isAvailable"] as! Bool
                    let itemCategory=document.data()["category"] as! String
                    items.append(ItemModels(itemId: itemId, itemName: itemName, itemThumbnail: itemThumbnail, itemDescription: itemDescription, itemPrice: itemPrice,itemDiscount: itemDiscount,isAvailable: isAvailable,category: itemCategory))
                }
                populateItemList(items: items)
                completion(items)
            }
        }
    }
    
    func GetCategoryAll(completion: @escaping (Any)->()){
        db.collection("categories").addSnapshotListener {
            querySnapshot, error in
            if let err = error {
                completion(500)
            }else{
                var categories:[CategoryModel]=[]
                for document in querySnapshot!.documents {
                    let categoryId=document.data()["categoryId"] as! String
                    let categoryName=document.data()["categoryName"] as! String
                    categories.append(CategoryModel(categoryId: categoryId, categoryName: categoryName))
                }
                populateCategoryList(categories: categories)
                completion(categories)
            }
        }
    }
    
    func AddCategoryNew(category:CategoryModel, completion: @escaping (Any)->()){
        db.collection("categories").document(category.categoryId).setData([
            "categoryId":category.categoryId,
            "categoryName":category.categoryName
        ]){ err in
            if err != nil{
                completion(500)
            } else {
                completion(201)
            }
        }
    }
    
    func getAllOrders(completion: @escaping (Any)->()){
        db.collection("orders").addSnapshotListener { querySnapshot, error in
            if let err = error {
                completion(500)
            }
            var orders:[OrderModel] = []
            for document in querySnapshot!.documents {
                var cart:[CartModel]=[]
                let orderId:String=document.data()["orderId"] as! String
                let userEmailAddress:String=document.data()["userEmailAddress"] as! String
                let items = document.data()["items"] as! [Any]
                for item in items{
                    let itemData = item as! [String:Any]
                    let itemId:String = itemData["itemId"] as! String
                    let itemName:String = itemData["itemName"] as! String
                    let itemQty:Int = itemData["itemQty"] as! Int
                    let itemPrice:Float = itemData["itemPrice"] as! Float
                    let totalPrice:Float = itemData["totalPrice"] as! Float
                    let cartItem = CartModel(itemId: itemId, itemName: itemName, itemQty: itemQty, itemPrice: itemPrice, totalPrice: totalPrice)
                    cart.append(cartItem)
                }
                let total:Float=document.data()[
                    "total"] as! Float
                let status:Int=document.data()["status"] as! Int
                let timestamp:Timestamp = document.data()["timestamp"] as! Timestamp
                let userId:String = document.data()["userId"] as! String
                orders.append(OrderModel(orderId: orderId, userEmailAddress: userEmailAddress, items: cart, total: total, status: status,userId: userId, timestamp:timestamp.dateValue()))
            }
            populateOrderList(orders: orders)
            completion(orders)
        }
    }
    
    let notificationService = NotificationService()
    
    func markStatusAsRecieved(orderStatusData:StatusData,key:String){
        orderStatusData.isRecieved=true
        let ref = Database.database().reference().child(UserData.uuid).child(key).setValue(orderStatusData.asDictionary)
    }
    
    func changeOrderStatus(orderId:String,userId:String,status:Int, completion: @escaping (Any)->()){
        db.collection("orders").document(orderId).updateData(["status":status]){
            err in
            if let err = err {
                completion(500)
            } else {
                FirebaseService().updateOrderStatus(orderId: orderId, status: status,userId: userId)
                completion(204)
            }
        }
    }
    
    func listenToOrderStatus(){
        let ref = Database.database().reference().child("orders")
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            if !snapshot.exists() {
                    return
            }
            var masterData = snapshot.value as! [String: [String:Any]]
            for (userId,value) in masterData{
                for (orderId,value) in value{
                    let statusData = value as! [String:Any]
                    var orderStatusData:StatusData=StatusData()
                    orderStatusData.orderId=statusData["orderId"] as! String
                    orderStatusData.status=statusData["status"] as! Int
                    orderStatusData.isRecieved=statusData["isRecieved"] as! Bool
                    if orderStatusData.status == 0 || orderStatusData.status == 3{
                        if orderStatusData.isRecieved == false{
                            self.notificationService.pushNotification(orderId: orderStatusData.orderId, orderStatus: orderStatusData.status){
                                result in
                                if result == true{
                                    self.markStatusAsRecieved(orderStatusData: orderStatusData, userId:userId, key: orderId)
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func updateOrderStatus(orderId:String,status:Int,userId:String){
        let ref = Database.database().reference().child("orders").child(userId).child(orderId)
        ref.updateChildValues(["status":status,"isRecieved":false])
    }
    
    func markStatusAsRecieved(orderStatusData:StatusData,userId:String,key:String){
        orderStatusData.isRecieved=true
        let ref = Database.database().reference().child("orders").child(userId).child(key).setValue(orderStatusData.asDictionary)
    }
    
    let storage = Storage.storage()
    
    func upload(data:Data,itemId:String,completion: @escaping (Any)->()){
        print("Started to upload")
        let storageRef = storage.reference()
        let itemImageRef = storageRef.child(itemId+".jpg")

        itemImageRef.putData(data, metadata: nil) { (metadata, error) in
            if (error == nil){
                print("Uploaded")
                itemImageRef.downloadURL(){
                    url,error in
                    if (error == nil){
                        completion(url?.absoluteString)
                    }else{
                        print("Unable to get download url")
                        completion("")
                    }
                }
            }else{
                completion("")
            }
        }
    }
    
    func addNewItem(item:ItemModels, completion: @escaping (Any)->()){
        db.collection("items").document(item.itemId).setData([
            "itemId":item.itemId,
            "itemName":item.itemName,
            "itemDescription":item.itemDescription,
            "itemThumbnail":item.itemThumbnail,
            "itemPrice":item.itemPrice,
            "itemDiscount":item.itemDiscount,
            "isAvailable":item.isAvailable,
            "category":item.category
        ]){ err in
            if err != nil{
                completion(500)
            } else {
                completion(201)
            }
        }
    }
    
    func getOrdersByDateRange(start:Date,end:Date,completion: @escaping (Any)->()){
        var orders:[OrderModel] = []
        db.collection("orders").whereField("timestamp",isGreaterThanOrEqualTo: end).whereField("timestamp", isLessThanOrEqualTo: start).getDocuments(){
            (querySnapshot, err) in
            if let err = err {
                completion(500)
            }else{
                for document in querySnapshot!.documents {
                    var cart:[CartModel]=[]
                    let orderId:String=document.data()["orderId"] as! String
                    let userEmailAddress:String=document.data()["userEmailAddress"] as! String
                    let items = document.data()["items"] as! [Any]
                    for item in items{
                        let itemData = item as! [String:Any]
                        let itemId:String = itemData["itemId"] as! String
                        let itemName:String = itemData["itemName"] as! String
                        let itemQty:Int = itemData["itemQty"] as! Int
                        let itemPrice:Float = itemData["itemPrice"] as! Float
                        let totalPrice:Float = itemData["totalPrice"] as! Float
                        let cartItem = CartModel(itemId: itemId, itemName: itemName, itemQty: itemQty, itemPrice: itemPrice, totalPrice: totalPrice)
                        cart.append(cartItem)
                    }
                    let total:Float=document.data()[
                        "total"] as! Float
                    let status:Int=document.data()["status"] as! Int
                    let timestamp:Timestamp = document.data()["timestamp"] as! Timestamp
                    let userId:String = document.data()["userId"] as! String
                    orders.append(OrderModel(orderId: orderId, userEmailAddress: userEmailAddress, items: cart, total: total, status: status,userId: userId, timestamp:timestamp.dateValue()))
                }
                populateBillOrderList(orders: orders)
                completion(orders)
            }
        }
    }
}


