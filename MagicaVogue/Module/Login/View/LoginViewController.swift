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
            
            Auth.auth().signIn(with: credential) {  authResult, error in
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
                }     }
        }
    }

    func signInWithGoogle(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResults = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResults.user)

    }
    @IBAction func skipButton(_ sender: Any) {
        let tab = TabBarController()
        self.navigationController?.setViewControllers([tab], animated: true)
        
    }

}
