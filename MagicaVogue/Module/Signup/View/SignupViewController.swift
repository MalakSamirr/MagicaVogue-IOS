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
                       // var user = Auth.auth().currentUser
                        //add()
                        createCustomer(userFirstName: username, userLastName: username, userPassword: password, userEmail: email, userPhoneNumber: phone) { result in
                            switch result {
                            case .success:
                                print("successsssss")
                                let address = ShippingDetailsVC()
                                self.navigationController?.setViewControllers([address], animated: true)
                                break
                                // Handle successful customer creation
                            case .failure(let error):
                                // Handle the error
                                print("Error: \(error.localizedDescription)")
                                let alert1 = UIAlertController(
                                    title: "Invalid Signup", message: "Error: \(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                                
                                let OkAction = UIAlertAction(title: "OK" , style : .default) { (action) in
                                    
                                }
                                
                                
                                alert1.addAction(OkAction)
                                
                                present(alert1, animated: true , completion: nil)
                               
                                return
                                
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
            
            
            let authResult = try await signInWithGoogle(credential: credential)
            
          //   saveUserSignedWithGoogleData()
            
            
            
            
            createCustomer(userFirstName: authResult.displayName! , userLastName: " ", userPassword: " ", userEmail: authResult.email!, userPhoneNumber: "") { result in
                switch result {
                case .success:
                    print("successsssss")
                    let address = ShippingDetailsVC()
                    self.navigationController?.setViewControllers([address], animated: true)
                    break
                    // Handle successful customer creation
                case .failure(let error):
                    // Handle the error
                    print("Error: \(error.localizedDescription)")
                    let alert1 = UIAlertController(
                        title: "Invalid Signup", message: "Error: \(error.localizedDescription)", preferredStyle: UIAlertController.Style.alert)
                    
                    let OkAction = UIAlertAction(title: "OK" , style : .default) { (action) in
                        
                    }
                    
                    
                    alert1.addAction(OkAction)
                    
                    self.present(alert1, animated: true , completion: nil)
                   
                    return
                    
                }
            }
           
            
           
            
        }
    }
    
    
   
    func signInWithGoogle(credential: AuthCredential) async throws -> AuthDataResultModel {
        let authDataResults = try await Auth.auth().signIn(with: credential)
        return AuthDataResultModel(user: authDataResults.user)

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
    
    
    
    func createCustomer(userFirstName: String, userLastName: String, userPassword: String, userEmail: String, userPhoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
           let url = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers.json"
           
           let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
           
           let parameters: [String: Any] = [
               "customer": [
                   "first_name": userFirstName,
                   "last_name": userLastName,
                   "tags": userPassword,
                   "phone": userPhoneNumber,
                   "email": userEmail,
                   "country": "CA"
               ]
           ]
           
           AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
               switch response.result {
               case .success:
                   if let statusCode = response.response?.statusCode, statusCode == 201 {
                       // HTTP Status Code 201 indicates success (Created)
                       print("Customer created successfully")
                       completion(.success(()))
                   } else {
                       print("Unexpected HTTP status code: \(response.response?.statusCode ?? -1)")
                       completion(.failure(NSError(domain: "YourAppErrorDomain", code: -1, userInfo: nil)))
                   }
               case .failure(let error):
                   print("Error: \(error.localizedDescription)")
                   completion(.failure(error))
               }
           }
       }
    
//    func createCustomer(userFirstName: String, userLastName: String, userPassword: String, userEmail: String, userPhoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
//        let url = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers.json"
//
//        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "sh-pat_b46703154d4c6d72d802123e5cd3f05a"]
//
//        let parameters: [String: Any] = [
//            "customer": [
//                "first_name": userFirstName,
//                "last_name": userLastName,
//                "tags": userPassword,
//                "phone": userPhoneNumber,
//                "email": userEmail,
//                "country": "CA"
//            ]
//        ]
//
//        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers).response { response in
//            switch response.result {
//            case .success:
//                if let statusCode = response.response?.statusCode, statusCode == 201 {
//                    // HTTP Status Code 201 indicates success (Created)
//                    print("Customer created successfully")
//                    completion(.success(()))
//                } else {
//                    print("Unexpected HTTP status code: \(response.response?.statusCode ?? -1)")
//                    completion(.failure(NSError(domain: "YourAppErrorDomain", code: -1, userInfo: nil)))
//                }
//            case .failure(let error):
//                print("Error: \(error.localizedDescription)")
//                completion(.failure(error))
//            }
//        }
//    }

    
    
//    func CreateCustomer (userFirstName : String , userLastName : String , userPassword : String , userEmail : String , userPhoneNumber : String   ,Handler: @escaping (Error?) -> Void){
//            let urlFile = "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/customers.json"
//            let body: [String: Any] =
//            ["customer":[
//                "first_name": userFirstName,
//                "last_name" : userLastName,
//                    "tags":  userPassword,
//                        "phone": userPhoneNumber,
//                        "email": userEmail,
//                        "country": "CA"
//
//             ]]
//                print(body)
//        AF.request(urlFile, method: .post)
//            .response { response in
//                switch response.result {
//                 case .success:
//
//                    print("success from create customer api in network services")
//                    Handler(nil)
//                    break
//                case .failure(let error):
//                    Handler(error)
//                    print(error.localizedDescription)
//                    print("error is from create customer api in network services")
//                            }
//                        }
//                    }
//
//
//
    
    
    
    
    
//    func add() {
//        let baseURLString = "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/"
//        let url = baseURLString + "customers.json"
//
//        let body: [String: Any] = [
//            "customer": [
//                "first_name": nameTextfield.text! ,
//                "tags": passwordTextfield.text!,
//                "phone": phoneTextfield.text!,
//                "email": emailTextfield.text!,
//                "country": "CA"
//            ]
//        ]
//
//        AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ["X-Shopify-Access-Token": "sh-pat_b46703154d4c6d72d802123e5cd3f05a"]).response { response in
//            switch response.result {
//            case .success(let data):
//                guard let data = data else { return }
//                //                print(String(data: data, encoding: .utf8) ?? "Nil")
//                do {
//
//
//                } catch {
//                    print(error)
//                }
//
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//
//
//    func saveUserSignedWithGoogleData(){
//        if let user = Auth.auth().currentUser {
//            let email = user.email
//            let displayName = user.displayName
//            let phoneNumber = user.phoneNumber
//
//            print("------------------")
//            print(email)
//            print(displayName)
//            print(phoneNumber)
//            print("---------------------")
//
//            // You can now use this user data as needed and send it to your API
//
//            let baseURLString = "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/"
//            let url = baseURLString + "customers.json"
//            let body: [String: Any] = [
//                "customer": [
//                    "email": email,
//                    "first_name": displayName,
//                    "phone": phoneNumber
//                ]
//            ]
//            AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: ["X-Shopify-Access-Token": "sh-pat_b46703154d4c6d72d802123e5cd3f05a"]).response { response in
//                switch response.result {
//                case .success(let data):
//                    guard let data = data else { return }
//                    do {
//
//                        print(String(data: data, encoding: .utf8) ?? "Nil")
//
//                    } catch {
//                        print(error)
//                    }
//
//                case .failure(let error):
//                    print(error)
//                }
//            }
//        }
//
//    }
//
    
    
    @IBAction func skipButton(_ sender: Any) {
        let tab = TabBarController()
        self.navigationController?.setViewControllers([tab], animated: true)
    }
    
}
