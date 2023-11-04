//
//  SignupViewController.swift
//  MagicaVogue
//
//  Created by Malak Samir on 18/10/2023.
//

import UIKit
import Firebase
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import Kingfisher
import Alamofire

class SignupViewController: UIViewController {
    var signupViewModel : SignupViewModel = SignupViewModel()
    
    var loginViewModel:LoginViewModel = LoginViewModel()
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    @IBOutlet weak var passwordImage: UIButton!
    
    @IBOutlet weak var confirmPasswordImage: UIButton!
    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var nameTextfield: UITextField!
    
    @IBOutlet weak var passwordTextfield: UITextField!
    
    
    @IBOutlet weak var phoneTextfield: UITextField!
    
    @IBOutlet weak var confirmPasswordTextfield: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.backBarButtonItem?.isHidden = true
        confirmPasswordTextfield.isSecureTextEntry = true
        passwordTextfield.isSecureTextEntry = true
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        
        if emailTextfield.text!.isEmpty || passwordTextfield.text!.isEmpty || confirmPasswordTextfield.text!.isEmpty || nameTextfield.text!.isEmpty || phoneTextfield.text!.isEmpty {
               self.displayAlert(title: "Invalid Signup", message: "Please fill in all the required information.")
           } else if passwordTextfield.text != confirmPasswordTextfield.text {
               self.displayAlert(title: "Invalid Signup", message: "The confirm password should be the same as the password, please check them and sign up again.")
           }
            else {
                if let email = emailTextfield.text , let password = passwordTextfield.text , let username = nameTextfield.text , let phone = phoneTextfield.text {
                    
                    Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
                        if let e = error {
                            
                            print(e.localizedDescription)
                            self.displayAlert(title: "Invalid Signup", message:  e.localizedDescription)
                        }
                        else {
                            // var user = Auth.auth().currentUser
                            //add()
                            signupViewModel.createCustomer(userFirstName: username, userLastName: username, userPassword: password, userEmail: email, userPhoneNumber: phone) { result in
                                switch result {
                                case .success:
                                    print("successsssss")
                                    self.loginViewModel.getCustomerID(email: email)
                                    let address = ShippingDetailsVC()
                                    address.email = email
                                    address.x = 1
                                    self.navigationController?.setViewControllers([address], animated: true)
                                 
                                    break
                                    // Handle successful customer creation
                                case .failure(let error):
                                    // Handle the error
                                    print("Error: \(error.localizedDescription)")
                                    self.displayAlert(title: "Invalid Signup", message: "Error: \(error.localizedDescription)")
                             
                                    
                                }
                            }
                            
                            
                        }
                    }
                }
                
            }
            
        }
        
        
        
        
        @IBAction func googleSignUpButton(_ sender: Any) {
            Task { @MainActor in
                
                guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                
                // Create Google Sign In configuration object.
                let config = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = config
                
                // Start the sign in flow!
                
                let gidSignResult = try await  GIDSignIn.sharedInstance.signIn(withPresenting: self)
                
                guard
                    let idToken = gidSignResult.user.idToken?.tokenString
                else {
                    throw URLError(.badServerResponse)
                }
                let accessToken : String = gidSignResult.user.accessToken.tokenString
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                               accessToken: accessToken)
                
                
                let authResult = try await loginViewModel.signInWithGoogle(credential: credential)
                
                
                
                
                
                signupViewModel.createCustomer(userFirstName: authResult.displayName! , userLastName: " ", userPassword: " ", userEmail: authResult.email!, userPhoneNumber: "") { result in
                    switch result {
                    case .success:
                        self.loginViewModel.getCustomerID(email: authResult.email!)
                        print("successsssss")
                        let address = ShippingDetailsVC()
                        address.email = authResult.email!
                        address.x = 1
                        
                        self.navigationController?.setViewControllers([address], animated: true)
                        break
                        // Handle successful customer creation
                    case .failure(let error):
                        // Handle the error
                        print("Error: \(error.localizedDescription)")
                        
                        self.displayAlert(title: "Invalid Signup", message: "Error: \(error.localizedDescription)")
                    }
                }
            }
        }
        
        @IBAction func loginButtonPressed(_ sender: Any) {
            print("hhhh")
            let loginVC = LoginViewController()
            self.navigationController?.pushViewController(loginVC, animated: true)
        }
        
        @IBAction func passwordButton(_ sender: AnyObject) {
            
            var image:UIImage!
            
            if signupViewModel.iconClick1
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
            signupViewModel.iconClick1 = !signupViewModel.iconClick1
            
        }
        
        @IBAction func confirmPasswordButton(_ sender: Any) {
            
            var image2:UIImage!
            
            if signupViewModel.iconClick2
            {
                confirmPasswordTextfield.isSecureTextEntry = false
                image2 = UIImage(systemName: "eye.fill")
            }
            else
            {
                confirmPasswordTextfield.isSecureTextEntry = true
                
                image2 = UIImage(systemName: "eye.slash.fill")
                
            }
            confirmPasswordImage.setImage(image2, for: .normal)
            signupViewModel.iconClick2 = !signupViewModel.iconClick2
             
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
