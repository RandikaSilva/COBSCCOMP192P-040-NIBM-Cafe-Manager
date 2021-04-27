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
        self.firebaseService.loginUser(emailAddress:txtEmailAddress.text!,password: txtPassword.text!)
        {(result:Int?)->Void in
            if(result==1){
                UserData.emailAddress=self.txtEmailAddress.text!
                firebaseFoodData.fetchFoodsData()
                { (resultFetch) -> () in
                    if(resultFetch){
                        firebaseFoodData.fetchUsersData(){
                            (resultFetch) -> () in
                            if(resultFetch){
                                let storeTabBarController = self.storyboard?.instantiateViewController(withIdentifier:"StoreTabBarController") as? StoreTabBarController
                                self.navigationController?.setNavigationBarHidden(true, animated: false)
                                self.navigationItem.leftBarButtonItem=nil
                                self.navigationItem.hidesBackButton=true
                                self.navigationController?.pushViewController(storeTabBarController!,animated: true)
                            }else{
                                self.showAlert(title:"Oops!",message:"Unable to load user data from server")
                            }
                        }
                    }else{
                        self.showAlert(title:"Oops!",message:"Unable to load food data from server")
                    }
                }
            }else if(result==2){
                self.showAlert(title: "Oops!", message: "Email is already registered")
            }else if(result==3){
                self.showAlert(title: "Oops!", message: "Username or password is incorrect")
            }else if(result==0){
                self.showAlert(title: "Oops!", message: "An error occures while registering")
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

