//
//  ShippingDetailsVC.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 22.10.2023.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift

protocol AddressDelegate: AnyObject {
    func didAddNewAddress(_ newAddress: Address)
}

class ShippingDetailsVC: UIViewController , UITextFieldDelegate{
    var loginViewModel : LoginViewModel = LoginViewModel()
    var viewModel = ShippingDetailsViewModel()
    let disposeBag = DisposeBag()
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
        phoneTextfield.delegate = self
        
        if let previousVC = navigationController?.viewControllers.first, previousVC is SignupViewController {
            cameFromSignup = true
        }
        navigationItem.setHidesBackButton(cameFromSignup, animated: true)
        setupBindings()
    }
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    func setupBindings() {
        viewModel.addressAddeddSuccessfully.skip(1)
            .bind { [weak self] success in
                //                self.addressDelegate?.didAddNewAddress(newAddress)
                DispatchQueue.main.async {[weak self] in
                    if success {
                        self?.showToast(message: "Address saved successfully")
                        self?.loginViewModel.getCustomer(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/customers.json?email=\(self?.email ?? "")"){ result in
                            switch result {
                            case .success(let customers):
                                print(customers)
                                
                            case .failure(let error):
                                print("Request failed with error: \(error.localizedDescription)")
                                
                            }}
                    } else {
                        self?.showRedToast(message: "Can't add address")
                    }
                }
            }
            .disposed(by: disposeBag)
    }
    
    @IBAction func saveAddressButton(_ sender: Any) {
        
        if isValidCity(city: cityTextfield.text) && isValidCountry(country: countryTextfield.text) && isValidAddress(address: addressTextfield.text) {
            if isValidPhone(phone: phoneTextfield.text!) {
                // Both city and country are valid, so you can add the address
                viewModel.addAddress(address1: addressTextfield.text, address2: countryTextfield.text, city: cityTextfield.text, phone: phoneTextfield.text)
            } else {
                // Display an error message for invalid phone number
                let alert = UIAlertController(title: "Invalid Phone Number", message: "Please add a valid phone number and try again!", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                present(alert, animated: true, completion: nil)
            }
        } else {
            // Display an error message for invalid city or country
            let alert = UIAlertController(title: "Invalid City or Country or Address", message: "Please enter a valid city ,country and address and try again!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
        
        if cameFromSignup {
            let tab = TabBarController()
            self.navigationController?.setViewControllers([tab], animated: true)
        }
    }
    func isValidAddress(address: String?) -> Bool {
        return address?.isEmpty == false
    }
    func isValidCity(city: String?) -> Bool {
        if let city = city, !city.isEmpty {
            let letters = CharacterSet.letters
            let cityCharacterSet = CharacterSet(charactersIn: city)
            return cityCharacterSet.isSubset(of: letters)
        }
        return false
    }

    func isValidCountry(country: String?) -> Bool {
        if let country = country, !country.isEmpty {
            let letters = CharacterSet.letters
            let countryCharacterSet = CharacterSet(charactersIn: country)
            return countryCharacterSet.isSubset(of: letters)
        }
        return false
    }
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
        
        UIView.animate(withDuration: 5.0, animations: {
            toastView.alpha = 0
        }) { _ in
            toastView.removeFromSuperview()
        }
    }
    func showUnavilabeItemToast(message: String) {
        let toastView = ToastView1(message: message)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.backgroundColor = .red
        view.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            toastView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        
        UIView.animate(withDuration: 8.0, animations: {
            toastView.alpha = 0
        }) { _ in
            toastView.removeFromSuperview()
        }
    }

    
}

