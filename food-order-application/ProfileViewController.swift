//
//  ProfileViewController.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var contact: UILabel!
    @IBOutlet weak var email: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        email.text=UserData.emailAddress
        contact.text=UserData.mobileNumber
    }
}
