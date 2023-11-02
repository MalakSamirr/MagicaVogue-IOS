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
    weak var tabBar : TabBarController?

    let profile = ProfileViewController()
      
      @IBOutlet weak var passwordImage: UIButton!
      
      var iconClick = true
    var viewModel : LoginViewModel = LoginViewModel()
    
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
                        
                        
                        
                        self.viewModel.getCustomers(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/customers.json?email=\(email)") { result in
                            switch result {
                            case .success(let customers):
                                // Handle the fetched customers
                                print(customers)
                                if customers.isEmpty==false{
                                    let tab = TabBarController()
                                    self.navigationController?.setViewControllers([tab], animated: true)
                                }else{
                                    let alert1 = UIAlertController(
                                    title: "Invalid Login", message: "Customer does not exist, please signup first" , preferredStyle: UIAlertController.Style.alert)
                                  let OkAction = UIAlertAction(title: "OK" , style : .default) { (action) in
                                 
                                     }
                                 
                                alert1.addAction(OkAction)
                               self.present(alert1, animated: true , completion: nil)
                                 
                                  return
                                }
                               
                            case .failure(let error):
                                // Handle the error
                                print("Request failed with error: \(error.localizedDescription)")
                                
                                let alert1 = UIAlertController(
                                title: "Invalid Login", message: "Customer does not exist, please signup first" , preferredStyle: UIAlertController.Style.alert)
                              let OkAction = UIAlertAction(title: "OK" , style : .default) { (action) in
                             
                                 }
                             
                            alert1.addAction(OkAction)
                           self.present(alert1, animated: true , completion: nil)
                             
                              return
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
        Task { @MainActor in
            guard let clientID = FirebaseApp.app()?.options.clientID else { return }
            
            // Create Google Sign In configuration object.
            let config = GIDConfiguration(clientID: clientID)
            GIDSignIn.sharedInstance.configuration = config
            
            let gidSignResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: self)
            
            guard
                    let idToken = gidSignResult.user.idToken?.tokenString
                else {
                    throw URLError(.badServerResponse)
                }
            let accessToken : String = gidSignResult.user.accessToken.tokenString
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: accessToken)
            
            let authResult = try await signInWithGoogle(credential: credential)
                    
            
            self.viewModel.getCustomers(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/customers.json?email=\(authResult.email ?? " ")") { result in
                switch result {
                case .success(let customers):
                    // Handle the fetched customers
                    print(customers)
                    if customers.isEmpty==false{
                        let tab = TabBarController()
                        self.navigationController?.setViewControllers([tab], animated: true)
                    }else{
                        let alert1 = UIAlertController(
                        title: "Invalid Login", message: "Customer does not exist, please signup first" , preferredStyle: UIAlertController.Style.alert)
                      let OkAction = UIAlertAction(title: "OK" , style : .default) { (action) in
                     
                         }
                     
                    alert1.addAction(OkAction)
                   self.present(alert1, animated: true , completion: nil)
                     
                      return
                    }
                   
                case .failure(let error):
                    // Handle the error
                    print("Request failed with error: \(error.localizedDescription)")
                    
                    let alert1 = UIAlertController(
                    title: "Invalid Login", message: "Customer does not exist, please signup first" , preferredStyle: UIAlertController.Style.alert)
                  let OkAction = UIAlertAction(title: "OK" , style : .default) { (action) in
                 
                     }
                 
                alert1.addAction(OkAction)
               self.present(alert1, animated: true , completion: nil)
                 
                  return
                }
            }

            
                }     }
        
   

    func signInWithGoogle(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResults = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResults.user)

    }
    
    
                                   
    @IBAction func skipButton(_ sender: Any) {
        let tab = TabBarController()
        self.navigationController?.setViewControllers([tab], animated: true)
        
    }

}
