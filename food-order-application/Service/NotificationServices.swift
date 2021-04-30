//
//  NotificationServices.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-30.
//

import UIKit

class NotificationService: NSObject {
    
    func configure(context:UNUserNotificationCenterDelegate,application:UIApplication){
        if #available(iOS 10.0, *) {
            let center = UNUserNotificationCenter.current()
            center.delegate = context
            center.requestAuthorization(options: [.sound,.alert,.badge]) { (granted, error) in
                if granted {
                    print("Notification Enable Successfully")
                }else{
                   print("Some Error Occure")
                }
            }
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
    }
    
    func registerNotification(title:String,subtitle:String,body:String,time:Double,isRepeat:Bool,orderId:String,completion:@escaping (Bool)->()){
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.subtitle = subtitle
        notificationContent.body = body
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: time, repeats: isRepeat)
        
        let req=UNNotificationRequest(identifier: orderId, content: notificationContent, trigger: trigger)
        
        UNUserNotificationCenter.current().add(req) { (error:Error?) in

        if error != nil {
            print(error?.localizedDescription ?? "some unknown error")
            completion(false)
        }
         
            completion(true)
        }
    }
    
    func pushNotification(orderId:String,orderStatus:Int,result:@escaping (Bool)->()){
        print("Setting push notification")
        switch orderStatus {
            case 0:
         
                self.registerNotification(title: "Alert", subtitle: "Order", body: "New order receved", time: 1.0, isRepeat: false, orderId: orderId){completion in
                    if completion==true{
                        result(true)
                    }else{
                        result(false)
                    }
                }
            case 3:
     
                self.registerNotification(title: "Alert", subtitle: "Order", body: "Customer is nearby the resturent..", time: 1.0, isRepeat: false, orderId: orderId){completion in
                    if completion==true{
                        result(true)
                    }else{
                        result(false)
                    }
                }
            default:
                print("Unexpected notification")
                result(false)
        }
    }
    
}

