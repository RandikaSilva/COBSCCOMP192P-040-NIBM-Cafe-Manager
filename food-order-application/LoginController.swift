//
//  LoginController.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//

import UIKit

class LoginController: UIViewController {
    
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblRegister: UILabel!
    @IBOutlet weak var lblForgetPassword: UILabel!
    
    var firebaseService=FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardHider()
        addTapFunctions()
    }
    
    @IBAction func loginUser(_ sender: Any) {
        if(txtEmailAddress.text != "" && txtPassword.text != ""){
            login()
        }else{
            showAlert(title: "Oops!", message: "Please fill all fields")
        }
    }

    @objc func registerTapFunction(sender:UITapGestureRecognizer) {
        let registerViewController = storyboard?.instantiateViewController(withIdentifier:"RegisterView") as? RegistrationController
        self.navigationItem.leftBarButtonItem=nil
        self.navigationItem.hidesBackButton=true
        self.navigationController?.pushViewController(registerViewController!, animated: true)
    }
    
    @objc func forgetPasswordTapFunction(sender:UITapGestureRecognizer) {
        let forgetPasswordViewController = storyboard?.instantiateViewController(withIdentifier:"ForgetPasswordView") as? ForgetPasswordViewController
        self.navigationItem.leftBarButtonItem=nil
        self.navigationItem.hidesBackButton=true
        self.navigationController?.pushViewController(forgetPasswordViewController!, animated: true)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func login(){
        let user = UserModel(emailAddress: txtEmailAddress.text!, password: txtPassword.text!)
        FirebaseService().login(user: user) {
            result in
            if result == 200{
                FirebaseService().fetchUser(user: user){
                    completion in
                    print(completion)
                    if completion is UserModel{
                        let user = completion as! UserModel
                        if user.type==1{
                            FirebaseService().listenToOrderStatus()
                            let storeTabBarController = self.storyboard?.instantiateViewController(withIdentifier:"StoreTabBarController") as? StoreTabBarController
                            self.navigationController?.setNavigationBarHidden(true, animated: false)
                            self.navigationItem.leftBarButtonItem=nil
                            self.navigationItem.hidesBackButton=true
                            self.navigationController?.pushViewController(storeTabBarController!,animated: true)
                        }else{
                            self.showAlert(title: "Oops!", message: "You are unauthorized")
                        }
                    }else{
                        self.showAlert(title: "Firestore Error", message: "Unable to fetch user data")
                    }
                }
            }else if(result==400){
                self.showAlert(title: "Oops!", message: "Email address and password is required")
            }else if(result==401){
                self.showAlert(title: "Oops!", message: "Username or password is incorrect")
            }else if(result==500){
                self.showAlert(title: "Oops!", message: "An error occures while logging")
            }
        }
    }
    
    func addKeyboardHider(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func addTapFunctions(){
        let registerTap = UITapGestureRecognizer(target: self, action: #selector(LoginController.registerTapFunction))
        lblRegister.isUserInteractionEnabled = true
        lblRegister.addGestureRecognizer(registerTap)
        
        let forgetPasswordTap = UITapGestureRecognizer(target: self, action: #selector(LoginController.forgetPasswordTapFunction))
        lblForgetPassword.isUserInteractionEnabled = true
        lblForgetPassword.addGestureRecognizer(forgetPasswordTap)
    }
    
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

