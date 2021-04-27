//
//  FoodViewController.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//


import UIKit
import MaterialComponents.MaterialButtons

class FoodViewController: UIViewController {
    @IBOutlet weak var imgFoodImage: UIImageView!
    @IBOutlet weak var lblFoodName: UILabel!
    @IBOutlet weak var lblFoodOffer: UILabel!
    @IBOutlet weak var lblFoodPrice: UILabel!
    @IBOutlet weak var txtvFoodDescription: UITextView!
    
    var foodDetails:ItemModel = ItemModel(foodId: 0, foodName: "", foodDescription:"", foodPrice: 0.0, foodPhoto: "", foodDiscount: 0.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFloatingButton()
        imgFoodImage.image = UIImage(named: foodDetails.foodPhoto)
        lblFoodName.text = foodDetails.foodName
        lblFoodOffer.text = String(format:"%.2f", foodDetails.foodPrice)
        lblFoodPrice.text = String(format:"%.2f", foodDetails.foodPrice)
        txtvFoodDescription.text = foodDetails.foodDescription
    }
    
    func setFloatingButton() {
        let floatingButton = MDCFloatingButton()
        floatingButton.mode = .expanded
        floatingButton.translatesAutoresizingMaskIntoConstraints = false
        floatingButton.setTitle("Add to cart", for: .normal)
        floatingButton.backgroundColor = .systemBlue
        floatingButton.addTarget(self, action: #selector(tap), for: .touchUpInside)
        view.addSubview(floatingButton)
        view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant:-50))
        view.addConstraint(NSLayoutConstraint(item: floatingButton, attribute: .centerX , relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0))
    }
    
    @objc func tap(_ sender: Any) {
        addNewItem(item: CartModel(foodId: foodDetails.foodId, foodName: foodDetails.foodName, foodQty: 1, totalPrice: foodDetails.foodPrice*1,foodPrice: foodDetails.foodPrice))
        let storeViewController = storyboard?.instantiateViewController(withIdentifier:"StorePageView") as? StorePageViewController
        self.navigationController?.pushViewController(storeViewController!, animated: true)
    }
    
}

