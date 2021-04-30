//
//  OrderController.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-29.
//


import UIKit

struct OrderObjects{
    var sectionName:String!
    var sectionObjects:[OrderModel]!
}

var orderObjectsArray=[OrderObjects]()

class OrderTableViewCell: UITableViewCell {
    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblOrderId: UILabel!
}

class OrderController: UIViewController {
    
    @IBOutlet weak var tblOrderTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseService().getAllOrders(){completion in
            print("Refreshing")
            self.makeCategoryArray()
            self.tblOrderTable.delegate=self
            self.tblOrderTable.dataSource=self
            self.tblOrderTable.reloadData()
        }
    }
    
    private func makeCategoryArray(){
        var sectionItem:[String:[OrderModel]]=[:]
        for order in OrderData.orderList{
            let statusName:String = self.mapOrderStatus(status:order.status)
            if !sectionItem.keys.contains(statusName){
                sectionItem[statusName]=[]
                sectionItem[statusName]?.append(order)
            }else{
                sectionItem[statusName]?.append(order)
            }
        }
        orderObjectsArray.removeAll()
        for (key,value) in sectionItem{
             orderObjectsArray.append(OrderObjects(sectionName: key, sectionObjects: value))
        }
    }
    
    private func mapOrderStatus(status:Int)->String{
        switch status {
        case 0:
            return "New"
        case 1:
            return "Preparing"
        case 2:
            return "Ready"
        case 3:
            return "Arriving"
        case 4:
            return "Done"
        case 5:
            return "Canceled"
        default:
            return "Other"
        }
    }
    
}

extension OrderController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderDetailsViewController = self.storyboard?.instantiateViewController(withIdentifier:"OrderDetailController") as? OrderDetailController
        orderDetailsViewController?.orderDetails = orderObjectsArray[indexPath.section].sectionObjects[indexPath.row]
        self.navigationController?.pushViewController(orderDetailsViewController!, animated: true)
    }
}

extension OrderController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return orderObjectsArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return orderObjectsArray[section].sectionName
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return orderObjectsArray.count
    }
    
    func numberOfSectionsInTableView(table:UITableView)->Int{
        return orderObjectsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "cellOrder") as! OrderTableViewCell
        
        cell.lblCustomerName.text=orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].userEmailAddress
        cell.lblOrderId.text=orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].orderId
        
        cell.btnReject.layer.cornerRadius = cell.btnReject.frame.width/2
        cell.btnReject.layer.masksToBounds = true
        
        cell.btnAccept.layer.cornerRadius = cell.btnAccept.frame.width/2
        cell.btnAccept.layer.masksToBounds = true
        
        if orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].status==0{
            cell.btnReject.isHidden=false
            cell.btnReject.setTitle("Reject", for: .normal)
            cell.btnReject.tag=indexPath.row
            cell.btnAccept.backgroundColor=UIColor.systemGreen
            cell.btnAccept.setTitle("Accept", for: .normal)
            cell.btnAccept.accessibilityIdentifier=orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].orderId+"_"+orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].userId
            cell.btnAccept.addTarget(self, action: #selector(self.acceptOrder(sender:)), for: .touchUpInside)
            cell.btnReject.addTarget(self, action: #selector(self.rejectOrder(sender:)), for: .touchUpInside)
            cell.btnReject.accessibilityIdentifier=orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].orderId+"_"+orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].userId
        }else{
            cell.btnReject.isHidden=true
            cell.btnAccept.backgroundColor=UIColor.systemYellow
            cell.btnAccept.setTitle(self.mapOrderStatus(status: orderObjectsArray[indexPath.section].sectionObjects[indexPath.row].status), for: .normal)
            cell.btnAccept.tag=indexPath.row
        }
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 4
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        cell.layer.masksToBounds = false
        return cell
    }
    
    @objc func acceptOrder(sender:UIButton){
        let orderId = String(sender.accessibilityIdentifier!.split(separator: "_").first!)
        let userId = String(sender.accessibilityIdentifier!.split(separator: "_").last!)
        print("------_>")
        print(orderId)
        print(userId)
        FirebaseService().changeOrderStatus(orderId: orderId, userId: userId, status: 1){
            completion in
        }
    }
    @objc func rejectOrder(sender:UIButton){
        let orderId = String(sender.accessibilityIdentifier!.split(separator: "_").first!)
        let userId = String(sender.accessibilityIdentifier!.split(separator: "_").last!)
        FirebaseService().changeOrderStatus(orderId: orderId,userId: userId , status: 5){
            completion in
        }
    }
}

