//
//  MyAddressesVC.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 19.10.2023.
//

import UIKit
import Alamofire


class MyAddressesVC: ViewController  , UITableViewDataSource , UITableViewDelegate , AddressDelegate {

    
    var addresses: [Address] = []
    var selectedAddress: Address?
    var selectedIndex: Int?
    func didAddNewAddress(_ newAddress: Address) {
          addresses.append(newAddress)
          selectedIndex = addresses.count - 1

          addressTable.reloadData()
      }

    @IBOutlet weak var addressTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAddress()
        if let savedIndex = UserDefaults.standard.value(forKey: "SelectedAddressIndex") as? Int,
            let selectedAddress = UserDefaults.standard.value(forKey: "SelectedAddress") as? Data,
            let decodedAddress = try? JSONDecoder().decode(Address.self, from: selectedAddress) {

             selectedIndex = savedIndex
             self.selectedAddress = decodedAddress
         }
        self.title = "Shipping Address"
        self.navigationController?.navigationBar.backgroundColor = .white
        addressTable.delegate = self
        addressTable.dataSource = self
//        addressTable.separatorStyle = .none
        addressTable.register(UINib(nibName: "NewAddressCell", bundle: nil), forCellReuseIdentifier: "NewAddressCell")
        addressTable.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Update the checkmark accessory on the last added address
        if let selectedIndex = selectedIndex {
            if selectedIndex < addresses.count {
                selectedAddress = addresses[selectedIndex]
                addressTable.reloadData()
            }
        }
        
        getAddress()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            
        getAddress()
       
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addresses.count
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let address = addresses[indexPath.row]

            deleteAddress(address)
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewAddressCell", for: indexPath) as! NewAddressCell
        let address = addresses[indexPath.row]
        
        let city = address.city ?? " "
        let country = address.address2 ?? ""
        
        let location = "\(city),\(country)."

        cell.addressLabel.text = address.address1
        cell.CityAndCountryLabel.text = location
        cell.phoneLabel.text = address.phone
        if address.isDefault == true {
                cell.accessoryType = .checkmark
                selectedIndex = indexPath.row
                selectedAddress = address
            } else {
                cell.accessoryType = .none
            }
    return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAddress = addresses[indexPath.row]
        
        if let previousSelectedIndex = selectedIndex {
            // Clear the checkmark from the previously selected row
            if let previousSelectedCell = tableView.cellForRow(at: IndexPath(row: previousSelectedIndex, section: 0)) {
                previousSelectedCell.accessoryType = .none
            }
        }
        
        setDefaultAddressForCustomer(selectedAddress) { success in
            if success {
                self.selectedAddress = selectedAddress
                self.selectedIndex = indexPath.row

                // Save the selected address and index to UserDefaults
                if let encodedAddress = try? JSONEncoder().encode(selectedAddress) {
                    UserDefaults.standard.set(encodedAddress, forKey: "SelectedAddress")
                    UserDefaults.standard.set(indexPath.row, forKey: "SelectedAddressIndex")
                }

                // Update the checkmark for the selected row
                if let selectedCell = tableView.cellForRow(at: indexPath) {
                    selectedCell.accessoryType = .checkmark
                }
            } else {
                // Handle the case where setting the default address fails
                // You can show an alert or take appropriate action
                print("Failed to set the default address.")
            }
        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        
    }


    func getAddress() {
           let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers/7495027327292/addresses.json"
           let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]

           AF.request(baseURLString, method: .get, encoding: JSONEncoding.default, headers: headers)
               .responseDecodable(of: Customer.self) { response in
                   switch response.result {
                   case .success(let customer):
                       if let addresses = customer.addresses {
                           self.addresses = addresses
                           DispatchQueue.main.async {
                               self.addressTable.reloadData()
                           }
                       } else {
                           self.showNoAddressesFoundMessage()
                       }
                   case .failure(let error):
                       print("Failed to fetch addresses. Error: \(error)")
                   }
               }
       }

       func showNoAddressesFoundMessage() {
           // Display a message to the user when no addresses are found
           let alert = UIAlertController(
               title: "No Addresses Found",
               message: "There are no addresses associated with this customer.",
               preferredStyle: .alert
           )
           let okAction = UIAlertAction(title: "OK", style: .default)
           alert.addAction(okAction)
           present(alert, animated: true, completion: nil)
       }
    
    func deleteAddress(_ address: Address) {
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers/7495027327292/addresses/\(address.id ?? 0).json"
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
        
        AF.request(baseURLString, method: .delete, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    // Successfully deleted the address from the server
                
                    if response.response?.statusCode ?? 400 >= 400 {
                        self.showRedToast(message: "Cannot delete the customer’s address")
                    } else {
                        if let index = self.addresses.firstIndex(of: address) {
                            self.addresses.remove(at: index)
                            self.addressTable.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
                        }
                        self.showDeleteSuccessAlert()

                    }
                    
                case .failure(let error):
                    // Handle error (e.g., show an alert)
                    self.showToast(message: "Cannot delete the customer’s address")
                    print("Failed to delete address. Error: \(error)")
                }
            }
    }

    func showDeleteSuccessAlert() {
        let alert = UIAlertController(
            title: "Address Deleted",
            message: "The selected address has been deleted.",
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }

    @IBAction func addNewAddress(_ sender: UIButton) {

        let addVC = ShippingDetailsVC()
        addVC.x = 2
        navigationController?.pushViewController(addVC, animated: true)

    }
    

    func setDefaultAddressForCustomer(_ address: Address, completion: @escaping (Bool) -> Void) {
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers/7495027327292/addresses/\(address.id ?? 0)/default.json"
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]

        AF.request(baseURLString, method: .put, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    print("Default address set successfully")
                    completion(true) // Notify success

                case .failure(let error):
                    print("Failed to set default address. Error: \(error)")
                    completion(false) // Notify failure
                }
            }
    }
   

}

