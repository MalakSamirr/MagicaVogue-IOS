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
import Alamofire

class LoginViewController: UIViewController {

      
      @IBOutlet weak var passwordImage: UIButton!
      
    var viewModel : LoginViewModel = LoginViewModel()
    
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var emailTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backBarButtonItem?.isHidden = true
    }

    @IBAction func LoginButton(_ sender: Any) {
        if emailTextfield.text!.isEmpty || passwordTextfield.text!.isEmpty
        {
            self.displayAlert(title: "Invalid Login", message: "Please fill email and password to login")
         
        }
        else {
            if let email = emailTextfield.text , let password = passwordTextfield.text {
                
                Auth.auth().signIn(withEmail: email, password: password) {  authResult, error in
                    if let e = error {
                        self.displayAlert(title: "Invalid Login", message: e.localizedDescription)
                        
                        
                    } else {
                        
                        
                        
                        self.viewModel.getCustomer(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/customers.json?email=\(email)") { result in
                            switch result {
                            case .success(let customers):
                                // Handle the fetched customers
                                print(customers)
                                if customers.isEmpty==false{
                                    let tab = TabBarController()
                                    self.navigationController?.setViewControllers([tab], animated: true)
                                }else{
                                    self.displayAlert(title: "Invalid Login", message: "Customer does not exist, please signup first")
                                }
                               
                            case .failure(let error):
                                // Handle the error
                                print("Request failed with error: \(error.localizedDescription)")
                                
                                self.displayAlert(title: "Invalid Login", message: "Customer does not exist, please signup first")
                            }
                        }

                        

                    }}}
            }
        }
        
    
    
    @IBAction func signupPageButton(_ sender: Any) {
        
        let signup = SignupViewController()
        self.navigationController?.pushViewController(signup, animated: true)
        
    }
    
    @IBAction func passwordButton(_ sender: AnyObject) {
        var image:UIImage!
        
        if viewModel.iconClick
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
        viewModel.iconClick = !viewModel.iconClick
        
    }
    
    
    
    
    @IBAction func googleLoginButton(_ sender: Any) {
        Task { @MainActor in
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            let gidSignResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: self)
            
            guard let idToken = gidSignResult.user.idToken?.tokenString else {
                throw URLError(.badServerResponse)
            }
            
            let accessToken: String = gidSignResult.user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            let authResult = try await viewModel.signInWithGoogle(credential: credential)
            
            self.viewModel.getCustomer(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/customers.json?email=\(authResult.email ?? " ")") { result in
                switch result {
                case .success(let customers):
                    // Handle the fetched customers
                    print(customers)
                    if customers.isEmpty == false {
                        let tab = TabBarController()
                        self.navigationController?.setViewControllers([tab], animated: true)
                    } else {
                        self.displayAlert(title: "Invalid Login", message: "Customer does not exist, please signup first")
                    }
                case .failure(let error):
                    // Handle the error
                    print("Request failed with error: \(error.localizedDescription)")
                    self.displayAlert(title: "Invalid Login", message: "Customer does not exist, please signup first")
                }
            }
        }
    }

   
    func displayAlert(title: String, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    
                                   
    @IBAction func skipButton(_ sender: Any) {
        let tab = TabBarController()
        self.navigationController?.setViewControllers([tab], animated: true)
        
    }

}
