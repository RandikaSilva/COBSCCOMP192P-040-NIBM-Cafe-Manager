//
//  AccountController.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-29.
//

import UIKit


struct BillObjects{
    var sectionName:String!
    var sectionObjects:[Any]!
    var sectionTotal:Float
}

var objectsBillArray=[BillObjects]()

class BillCellViewController:UITableViewCell{
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblOrderTotal: UILabel!
}

class BillCellPrintViewController:UITableViewCell{
    @IBOutlet weak var lblTotalDay: UILabel!
    @IBOutlet weak var btnPrint: UIButton!
}

class AccountController: UIViewController {
    
    var sectionItem:[String:[Any]]=[:]
    var grandTotal:Float=0.0
    var startDate:Date=Date()
    var endDate:Date=Calendar.current.date(byAdding: .day, value: -7, to: Date())!
    
    @IBOutlet weak var pkrStartDate: UIDatePicker!
    @IBOutlet weak var pkrEndDate: UIDatePicker!
    @IBOutlet weak var btnPrintHistory: UIButton!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var tblBill: UITableView!
    
    @IBAction func pkrStartDate(sender: UIDatePicker) {
        self.startDate=sender.date
        self.pkrEndDate.maximumDate=self.startDate
        self.pkrEndDate.isHidden=false
    }
    
    @IBAction func pkrEndDate(sender: UIDatePicker) {
        self.endDate=sender.date
        self.pkrStartDate.minimumDate=self.endDate
        FirebaseService().getOrdersByDateRange(start: self.startDate, end:self.endDate ){
            completion in
            self.makeDateArray(isFilter: true)
            self.tblBill.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FirebaseService().getAllOrders(){
            completion in
            self.makeDateArray(isFilter: false)
            self.tblBill.delegate=self
            self.tblBill.dataSource=self
            self.pkrEndDate.isHidden=true
            self.tblBill.reloadData()
        }
        
    }

    private func makeDateArray(isFilter:Bool){
        objectsBillArray.removeAll()
        self.sectionItem.removeAll()
        self.grandTotal=0.0
        
        var orders:[OrderModel]!
        
        if isFilter{
            orders=OrderBillData.billOrderList
        }else{
            orders=OrderData.orderList
        }
        
        for order in orders{
            let dateFormatter=DateFormatter()
            dateFormatter.dateFormat = "YYYY/MM/dd"
            let sectionName = dateFormatter.string(from: order.timestamp)
            
            if !self.sectionItem.keys.contains(sectionName){
                self.sectionItem[sectionName]=[]
                self.sectionItem[sectionName]?.append(order)
            }else{
                self.sectionItem[sectionName]?.append(order)
            }
        }
        for (key,_) in self.sectionItem{
            self.sectionItem[key]?.append(true)
        }
        for (key,value) in self.sectionItem{
            var sectionTotal:Float=0.0
            for sectionOrder in value{
                if sectionOrder is OrderModel{
                    let sectionOrderData = sectionOrder as! OrderModel
                    sectionTotal+=sectionOrderData.total
                }
            }
            self.grandTotal+=sectionTotal
            objectsBillArray.append(BillObjects(sectionName: key, sectionObjects: value,sectionTotal:sectionTotal))
        }
        
        self.lblTotal.text = (String(self.grandTotal)=="0.0") ? "No Sale" : String(self.grandTotal)
    }
}

extension AccountController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension AccountController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsBillArray[section].sectionObjects.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsBillArray[section].sectionName
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.systemGreen
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(objectsBillArray[indexPath.section].sectionObjects[indexPath.row] is OrderModel){
            return 80
        }else{
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(objectsBillArray[indexPath.section].sectionObjects[indexPath.row] is OrderModel){
            let orderData = objectsBillArray[indexPath.section].sectionObjects[indexPath.row] as! OrderModel
            
            let cell:BillCellViewController =  tableView.dequeueReusableCell(withIdentifier: "cellBill") as! BillCellViewController
            
            cell.lblOrderId.text=orderData.orderId
            cell.lblOrderTotal.text=String(orderData.total)
            
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 4
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
            cell.layer.masksToBounds = false
            return cell
        }else{
            let cell:BillCellPrintViewController =  tableView.dequeueReusableCell(withIdentifier: "cellBillPrint") as! BillCellPrintViewController
            
            cell.lblTotalDay.text="Day total: "+String(objectsBillArray[indexPath.section].sectionTotal)
            
            cell.layer.backgroundColor = UIColor.systemGray.cgColor
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 4
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
            cell.layer.masksToBounds = false
            return cell
        }
    }
}

