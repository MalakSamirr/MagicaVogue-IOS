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
    
    var iconClick1 = true
    var iconClick2 = true
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
        print("ghjj")
        // Do any additional setup after loading the view.
        navigationItem.backBarButtonItem?.isHidden = true

        
        confirmPasswordTextfield.isSecureTextEntry = true
        passwordTextfield.isSecureTextEntry = true
    }
    
    @IBAction func SignUpButton(_ sender: Any) {
        
        if emailTextfield.text!.isEmpty || passwordTextfield.text!.isEmpty || confirmPasswordTextfield.text!.isEmpty || nameTextfield.text!.isEmpty || phoneTextfield.text!.isEmpty
        {
            let alert1 = UIAlertController(
                title: "Invalid Signup", message: "Please fill these informations to create your account", preferredStyle: UIAlertController.Style.alert)
            
            let OkAction = UIAlertAction(title: "OK" , style : .default) { (action) in
                
            }
            
            
            alert1.addAction(OkAction)
            
            present(alert1, animated: true , completion: nil)
            
            
            return
        }
        
        
        else if passwordTextfield.text != confirmPasswordTextfield.text {
            
            let alert1 = UIAlertController(
                title: "Invalid Signup", message: "The confirm password should be the same as the password , please check them and signup again.", preferredStyle: UIAlertController.Style.alert)
            
            let OkAction = UIAlertAction(title: "OK" , style : .default) { (action) in
                
            }
            
            
            alert1.addAction(OkAction)
            
            present(alert1, animated: true , completion: nil)
            
            
            return
            
        }
        else {
            if let email = emailTextfield.text , let password = passwordTextfield.text , let username = nameTextfield.text , let phone = phoneTextfield.text {
                
                Auth.auth().createUser(withEmail: email, password: password) { [self] authResult, error in
                    if let e = error {
                        
                        print(e.localizedDescription)
                        let alert1 = UIAlertController(
                            title: "Invalid Signup", message: e.localizedDescription , preferredStyle: UIAlertController.Style.alert)
                        
                        let OkAction = UIAlertAction(title: "OK" , style : .default) { (action) in
                            
                        }
                        
                        
                        alert1.addAction(OkAction)
                        
                        self.present(alert1, animated: true , completion: nil)
                        
                        
                        return
                        
                    }
                    else {
                        var user = Auth.auth().currentUser
                        add()
                        let address = ShippingDetailsVC()
                        self.navigationController?.setViewControllers([address], animated: true)
                        
                        
                        
                        
                    }
                }
            }
            
        }
        
    }
    
    
    
    
    @IBAction func googleSignUpButton(_ sender: Any) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Start the sign in flow!
        GIDSignIn.sharedInstance.signIn(withPresenting: self) { [unowned self] result, error in
            guard error == nil else {
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString
            else {
                return
            }
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: user.accessToken.tokenString)
            
            // ...
            let tab = TabBarController()
            self.navigationController?.setViewControllers([tab], animated: true)
            
            saveUserSignedWithGoogleData()
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        print("hhhh")
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func login(_ sender: Any) {
        print("hhhh")
        let loginVC = LoginViewController()
        self.navigationController?.pushViewController(loginVC, animated: true)
    }
    
    @IBAction func passwordButton(_ sender: AnyObject) {
        
        var image:UIImage!
        
        if iconClick1
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
        iconClick1 = !iconClick1
        
    }
    
    
    
    @IBAction func confirmPasswordButton(_ sender: Any) {
        
        var image2:UIImage!
        
        if iconClick2
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
        iconClick2 = !iconClick2
        
        
    }
    
    func add() {
        let baseURLString = "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/"
        let url = baseURLString + "customers.json"
        
        let body: [String: Any] = [
            "customer": [
                "first_name": nameTextfield.text! ,
                "tags": passwordTextfield.text!,
                "phone": phoneTextfield.text!,
                "email": emailTextfield.text!,
                "country": "CA"
            ]
        ]
        
        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ["X-Shopify-Access-Token": "sh-pat_b46703154d4c6d72d802123e5cd3f05a"]).response { response in
            switch response.result {
            case .success(let data):
                guard let data = data else { return }
                //                print(String(data: data, encoding: .utf8) ?? "Nil")
                do {
                    
                    
                } catch {
                    print(error)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func saveUserSignedWithGoogleData(){
        if let user = Auth.auth().currentUser {
            let email = user.email
            let displayName = user.displayName
            let phoneNumber = user.phoneNumber
            
            print("------------------")
            print(email)
            print(displayName)
            print(phoneNumber)
            print("---------------------")
            
            // You can now use this user data as needed and send it to your API
            
            let baseURLString = "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/"
            let url = baseURLString + "customers.json"
            let body: [String: Any] = [
                "customer": [
                    "email": email,
                    "first_name": displayName,
                    "phone": phoneNumber
                ]
            ]
            AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ["X-Shopify-Access-Token": "sh-pat_b46703154d4c6d72d802123e5cd3f05a"]).response { response in
                switch response.result {
                case .success(let data):
                    guard let data = data else { return }
                    //                print(String(data: data, encoding: .utf8) ?? "Nil")
                    do {
                        
                        
                    } catch {
                        print(error)
                    }
                    
                case .failure(let error):
                    print(error)
                }
            }
        }
        
    }
    
    
    
    @IBAction func skipButton(_ sender: Any) {
        let home = HomeViewController()
        self.navigationController?.pushViewController(home, animated: true)
    }
    
}
