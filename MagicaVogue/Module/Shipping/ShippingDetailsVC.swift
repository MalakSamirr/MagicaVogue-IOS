//
//  ShippingDetailsVC.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 22.10.2023.
//

import UIKit
import Alamofire
protocol AddressDelegate: AnyObject {
    func didAddNewAddress(_ newAddress: Address)
}




class ShippingDetailsVC: UIViewController {
    var loginViewModel : LoginViewModel = LoginViewModel()
    var email : String = ""
    
    var onAddressAdded: ((Address) -> Void)?
    weak var addressDelegate: AddressDelegate?


    @IBOutlet weak var cityTextfield: UITextField!
    
    @IBOutlet weak var countryTextfield: UITextField!
    
    @IBOutlet weak var addressTextfield: UITextField!

    @IBOutlet weak var phoneTextfield: UITextField!
    
    var cameFromSignup: Bool = false


    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let previousVC = navigationController?.viewControllers.first, previousVC is SignupViewController {
            cameFromSignup = true
        }
        navigationItem.setHidesBackButton(cameFromSignup, animated: true)
        
    }
    


    func addAddress() {
       let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers/7495027327292/addresses.json"
       let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]

        let addressData: [String: Any] = [
           "address": [
            "address1": addressTextfield.text ?? "" ,
            "address2": countryTextfield.text,//country
            "city": cityTextfield.text ?? "",
            "company": "Fancy Co.",
            "phone": phoneTextfield.text ?? "",
            "province": "Quebec",
            "country": "Canda",
            "zip": "G1R 4P5",
            "name": "Samuel de Champlain",
            "province_code": "QC",
            "country_code": "CA",
            "country_name": "Egypt",
            "default": true
           ]
       ]

       AF.request(baseURLString, method: .post, parameters: addressData, encoding: JSONEncoding.default, headers: headers)
           .response { response in
               switch response.result {
               case .success:
                   
                               if let data = response.data {
                                   do {
                                       let newAddress = try JSONDecoder().decode(Address.self, from: data)
                                       self.onAddressAdded?(newAddress)
                                       print("Address added successfully")
                                       
                                       // Notify the delegate about the new address
                                       self.addressDelegate?.didAddNewAddress(newAddress)
                                   } catch {
                                       print("Failed to decode the address. Error: \(error)")
                                   }
                               }
               case .failure(let error):
                   print("Failed to add the address. Error: \(error)")
              }
           }
    }
    
        showToast(message: "Address saved successfully")
     @IBAction func saveAddressButton(_ sender: Any) {
         addAddress()
         self.loginViewModel.getCustomer(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/customers.json?email=\(email)"){ result in
             switch result {
             case .success(let customers):
                 // Handle the fetched customers
                 print(customers)
                 
             case .failure(let error):
                 // Handle the error
                 print("Request failed with error: \(error.localizedDescription)")
                 
             }}
          let tab = TabBarController()
          self.navigationController?.setViewControllers([tab], animated: true)
     }
   


extension UIViewController {
    func showToast(message: String) {
        let toastView = ToastView1(message: message)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toastView)

        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            toastView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        UIView.animate(withDuration: 8.0, animations: {
            toastView.alpha = 0
        }) { _ in
            toastView.removeFromSuperview()
        }
    }
    func showRedToast(message: String) {
        let toastView = ToastView2(message: message)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(toastView)

        NSLayoutConstraint.activate([
            toastView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            toastView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            toastView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])

        UIView.animate(withDuration: 8.0, animations: {
            toastView.alpha = 0
        }) { _ in
            toastView.removeFromSuperview()
        }
    }
    
 
}
