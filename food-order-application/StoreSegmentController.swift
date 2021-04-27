//
//  StoreSegmentController.swift
//  food-order-application
//
//  Created by Lasitha on 2021-04-26.
//

import UIKit;

class StoreSegmentController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad();
    }
    
    @IBAction func didChangeSegment(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            view.backgroundColor = .red;
        }else if sender.selectedSegmentIndex == 1{
            view.backgroundColor = .blue;
        }
        
    }

}
