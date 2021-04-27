//
//  StorePageController.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//

import UIKit
import MaterialComponents.MaterialButtons

class StoreTableCustomCell: UITableViewCell {
    @IBOutlet weak var imgFoodImage: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodDescription: UILabel!
    @IBOutlet weak var lblFoodPrice: UILabel!
    @IBOutlet weak var lblFoodDiscount: UILabel!
    
}

class CartTableCustomCell: UITableViewCell {
    @IBOutlet weak var lblCartFoodName: UILabel!
    @IBOutlet weak var stpFoodQty: UIStepper!
    @IBOutlet weak var lblCartFoodPrice: UILabel!
}

class StorePageViewController: UIViewController {

    @IBOutlet weak var storeTableView: UITableView!
    @IBOutlet weak var cartTableView: UITableView!
    @IBOutlet weak var lblItemCount: UILabel!
    @IBOutlet weak var foodCartView: UIView!
    @IBOutlet weak var lblQtyCount: UIStepper!
    
    var firebaseFoodData=FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatingButton()
        lblItemCount.text!=String(CartData.cartList.count)+" Items"
        storeTableView.delegate=self
        storeTableView.dataSource=self
        cartTableView.delegate=self
        cartTableView.dataSource=self
        foodCartView.isHidden = (CartData.cartList.count==0 ? true:false)
        storeTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        cartTableView.reloadData()
        storeTableView.reloadData()
        lblItemCount.text!=String(CartData.cartList.count)+" Items"
        foodCartView.isHidden = (CartData.cartList.count==0 ? true:false)
    }
    
    func setFloatingButton() {
        let floatingButton = MDCFloatingButton()
        floatingButton.mode = .expanded
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.setTitle("Order", for: .normal)
        floatingButton.backgroundColor = .systemBlue
        floatingButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        view.addSubview(floatingButton)
        view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant:-50))
        view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
    }
    
    @objc func tap(_ sender: Any) {
        addNewOrder(order: OrderModel(orderId: OrderData.orderId, orderStatus: "Pending"))
        removeCart()
        let orderViewController = storyboard?.instantiateViewController(withIdentifier:"OrderView") as? OrderViewController
        self.navigationController?.pushViewController(orderViewController!, animated: true)
    }
    @IBAction func stpQtyUpdate(_ sender: UIStepper) {
        let foodId = sender.accessibilityIdentifier
        for item in CartData.cartList{
            if(String(item.foodId)==foodId){
                item.foodQty=Int(sender.value)
                item.totalPrice=item.foodPrice * Float(item.foodQty)
            }
        }
        cartTableView.reloadData()
    }
    
}

extension StorePageViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let foodViewController = storyboard?.instantiateViewController(withIdentifier:"FoodView") as? FoodViewController
        foodViewController?.foodDetails = FoodData.foodList[indexPath.row]
        self.navigationController?.pushViewController(foodViewController!, animated: true)
    }
}

extension StorePageViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == storeTableView{
            return FoodData.foodList.count
        }else if tableView == cartTableView{
            return CartData.cartList.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == storeTableView{
            let cell:StoreTableCustomCell =  tableView.dequeueReusableCell(withIdentifier: "tbvCell") as! StoreTableCustomCell
            cell.imgFoodImage.image = UIImage(named: FoodData.foodList[indexPath.row].foodPhoto)
            cell.lblFoodName.text = FoodData.foodList[indexPath.row].foodName
            cell.lblFoodDescription.text = FoodData.foodList[indexPath.row].foodDescription
            cell.lblFoodPrice.text = String(format:"%.2f", FoodData.foodList[indexPath.row].foodPrice)
            cell.lblFoodDiscount.text = String(format:"%.2f", FoodData.foodList[indexPath.row].foodDiscount)
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 4
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
            cell.layer.masksToBounds = false
            return cell
        }else if tableView == cartTableView{
            let cell:CartTableCustomCell =  tableView.dequeueReusableCell(withIdentifier: "tbvCartCell") as! CartTableCustomCell
            cell.lblCartFoodName.text=CartData.cartList[indexPath.row].foodName
            cell.stpFoodQty.accessibilityIdentifier=String(CartData.cartList[indexPath.row].foodId)
            cell.lblCartFoodPrice.text=String(format:"%.2f", CartData.cartList[indexPath.row].totalPrice)
            cell.layer.backgroundColor = UIColor.clear.cgColor
            cell.layer.shadowColor = UIColor.black.cgColor
            cell.layer.shadowOffset = CGSize(width: 0, height: 0)
            cell.layer.shadowRadius = 4
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowPath = UIBezierPath(rect: cell.bounds).cgPath
            cell.layer.masksToBounds = false
            return cell
        }else{
            let cell:UITableViewCell=UITableViewCell()
            return cell
        }
        
    }
}
