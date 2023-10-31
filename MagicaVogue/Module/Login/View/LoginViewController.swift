//
//  LoginViewController.swift
//  MagicaVogue
//
//  Created by Malak Samir on 18/10/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn

class LoginViewController: UIViewController {
    weak var tabBar : TabBarController?

    let profile = ProfileViewController()
      
      @IBOutlet weak var passwordImage: UIButton!
      
      var iconClick = true
    
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem?.isHidden = true
        // Do any additional setup after loading the view.
    }

    @IBAction func LoginButton(_ sender: Any) {
       // self.view.endEditing(true)
        if emailTextfield.text!.isEmpty || passwordTextfield.text!.isEmpty
        {
            let alert1 = UIAlertController(
                title: "Invalid Login", message: "Please fill email and password to login", preferredStyle: UIAlertController.Style.alert)
            
            let OkAction = UIAlertAction(title: "OK" , style : .default) { (action) in
                
            }
            
            
            alert1.addAction(OkAction)
            
            present(alert1, animated: true , completion: nil)
            
          
            return
        }
        else {
            if let email = emailTextfield.text , let password = passwordTextfield.text {
            
            Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                if let e = error {
                    
                    let alert1 = UIAlertController(
                        title: "Invalid Login", message: e.localizedDescription , preferredStyle: UIAlertController.Style.alert)
                    
                    let OkAction = UIAlertAction(title: "OK" , style : .default) { (action) in
                        
                    }
                    
                    
                    alert1.addAction(OkAction)
                    
                    self.present(alert1, animated: true , completion: nil)
                    
                  
                    return
                    
                    print(e.localizedDescription)
                    
                } else {
                   
                    let tab = TabBarController()
                    self.navigationController?.setViewControllers([tab], animated: true)
                }
                    
                    
                }
              
            }
            
            }
        }
        
    
    
    @IBAction func signupPageButton(_ sender: Any) {
        
        let signup = SignupViewController()
        self.navigationController?.pushViewController(signup, animated: true)
        
    }
    
    @IBAction func passwordButton(_ sender: AnyObject) {
        var image:UIImage!
        
        if iconClick
        {
            passwordTextfield.isSecureTextEntry = false
             image = UIImage(systemName: "eye.fill")
        }
        else
        {
            passwordTextfield.isSecureTextEntry = true
            
             image = UIImage(systemName: "eye.slash.fill")

        }
        passwordImage.setImage(image, for: .normal)
        iconClick = !iconClick
        
    }
    
    
    
    
    
    @IBAction func googleLoginButton(_ sender: Any) {
        if let email = emailTextfield.text , let password = passwordTextfield.text{
            
            Auth.auth().signIn( withEmail: email, password: password) { result, error in
                
                // At this point, our user is signed in
                let tab = TabBarController()
                self.navigationController?.setViewControllers([tab], animated: true)
            }
        }
        
    }
    
    @IBAction func skipButton(_ sender: Any) {
        let tab = TabBarController()
        self.navigationController?.setViewControllers([tab], animated: true)
        
    }

}
