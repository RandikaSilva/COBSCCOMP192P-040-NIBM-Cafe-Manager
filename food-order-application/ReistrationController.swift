//
//  ReistrationController.swift
//  food-order-application
//
//  Created by Lasitha on 2021-03-05.
//


import UIKit

class RegistrationController: UIViewController {
    
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var txtMobileNumber: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var lblLogin: UILabel!
    
    var firebaseService=FirebaseService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addKeyboardHider()
        addTapFunctions()
    }
    
    @objc func tapFunction(sender:UITapGestureRecognizer) {
        let loginViewController = storyboard?.instantiateViewController(withIdentifier:"LoginView") as? LoginController
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.navigationItem.leftBarButtonItem=nil
        self.navigationItem.hidesBackButton=true
        self.navigationController?.pushViewController(loginViewController!, animated: true)
    }
    
    @IBAction func registerButton(_ sender: Any) {
        if(txtEmailAddress.text != "" && txtPassword.text != "" && txtMobileNumber.text != ""){
            if(txtPassword.text!.count>=8){
                if(txtMobileNumber.text!.count==10){
                    register()
                }else{
                    showAlert(title: "Oops!", message: "Mobile number needs to be 10 digits")
                }
            }else{
                showAlert(title: "Oops!", message: "Password needs to be at least 8 digits")
            }
        }else{
            showAlert(title: "Oops!", message: "Please fill all fields")
        }
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addKeyboardHider(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func showAlert(title:String,message:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func addTapFunctions(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(RegistrationController.tapFunction))
        lblLogin.isUserInteractionEnabled = true
        lblLogin.addGestureRecognizer(tap)
    }
    
    func register(){
        
        
        self.firebaseService.registerUser(emailAddress:txtEmailAddress.text!, mobileNumber: txtMobileNumber.text!, password: txtPassword.text!)
        {(result:Int?)->Void in
            if(result==1){
                firebaseFoodData.fetchFoodsData()
                { (resultFetch) -> () in
                    if(resultFetch){
                        self.firebaseService.addUserToFirestore(user: UserModel(emailAddress: self.txtEmailAddress.text!, mobileNumber: self.txtMobileNumber.text!))
                        UserData.emailAddress=self.txtEmailAddress.text!
                        UserData.mobileNumber=self.txtMobileNumber.text!
                        let storeTabBarController = self.storyboard?.instantiateViewController(withIdentifier:"StoreTabBarController") as? StoreTabBarController
                        self.navigationController?.setNavigationBarHidden(true, animated: false)
                        self.navigationItem.leftBarButtonItem=nil
                        self.navigationItem.hidesBackButton=true
                        self.navigationController?.pushViewController(storeTabBarController!,animated: true)
                    }else{
                        self.showAlert(title:"Oops!",message:"Unable to load food data from server")
                    }
                }
            }else if(result==2){
                self.showAlert(title: "Oops!", message: "Email is already registered")
            }else if(result==0){
                self.showAlert(title: "Oops!", message: "An error occures while registering")
            }
        }
    }
}
