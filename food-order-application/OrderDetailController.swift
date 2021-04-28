//
//  OrderDetailController.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-29.
//


import UIKit

class CartTableViewCell: UITableViewCell {
    @IBOutlet weak var lblItemName: UILabel!
    @IBOutlet weak var lblItemPrice: UILabel!
    @IBOutlet weak var lblItemQty: UILabel!
}

class OrderDetailController: UIViewController {

    @IBOutlet weak var tblCartDetails: UITableView!
    @IBOutlet weak var lblCustomerName: UILabel!
    @IBOutlet weak var lblOrderStatus: UIButton!
    @IBOutlet weak var lblTimeRemaining: UILabel!
    @IBOutlet weak var btnCall: UIButton!
    
    var orderDetails:OrderModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblOrderStatus.layer.cornerRadius = self.lblOrderStatus.frame.width/2
        self.lblOrderStatus.layer.masksToBounds = true
        self.lblCustomerName.text=orderDetails.userEmailAddress+"("+orderDetails.orderId+")"
        self.lblOrderStatus.setTitle(mapOrderStatus(status: orderDetails.status), for: .normal)
        self.lblTimeRemaining.text="Calculating"
        
        self.tblCartDetails.delegate=self
        self.tblCartDetails.dataSource=self
        self.tblCartDetails.reloadData()
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

extension OrderDetailController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let orderViewController = self.storyboard?.instantiateViewController(withIdentifier:"OrderView") as? OrderController
        
        self.navigationController?.pushViewController(orderViewController!, animated: true)
    }
}

extension OrderDetailController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderDetails.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CartTableViewCell =  tableView.dequeueReusableCell(withIdentifier: "cellCartDetails") as! CartTableViewCell
        
        cell.lblItemQty.text=String(orderDetails.items[indexPath.row].itemQty)
        cell.lblItemName.text=orderDetails.items[indexPath.row].itemName
        cell.lblItemPrice.text=String(orderDetails.items[indexPath.row].itemPrice*Float(orderDetails.items[indexPath.row].itemQty))
        
        cell.layer.backgroundColor = UIColor.clear.cgColor
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowRadius = 4
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
        cell.layer.masksToBounds = false
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

