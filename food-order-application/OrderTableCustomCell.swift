//
//  OrderTableCustomCell.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//

import UIKit


class OrderTableCustomCell: UITableViewCell {
    
    @IBOutlet weak var lblOrderId: UILabel!
    @IBOutlet weak var lblOrderStatus: UILabel!
}

class OrderViewController: UIViewController {
    @IBOutlet weak var tableOrderView: UITableView!
    @IBOutlet weak var noDataView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableOrderView.delegate=self
        tableOrderView.dataSource=self
        tableOrderView.isHidden = (OrderData.orderList.count == 0 ?true:false)
        noDataView.isHidden = (OrderData.orderList.count == 0 ?false:true)
    }
}

extension OrderViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension OrderViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return OrderData.orderList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:OrderTableCustomCell =  tableView.dequeueReusableCell(withIdentifier: "tblOrderData") as! OrderTableCustomCell
        cell.lblOrderId.text = "Order ID "+String(OrderData.orderList[indexPath.row].orderId)
        cell.lblOrderStatus.text = OrderData.orderList[indexPath.row].orderStatus
        return cell
    }
}
