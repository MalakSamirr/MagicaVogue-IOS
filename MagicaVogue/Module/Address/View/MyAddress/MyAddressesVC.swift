//
//  MyAddressesVC.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 19.10.2023.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift

class MyAddressesVC: ViewController  , UITableViewDataSource , UITableViewDelegate , AddressDelegate {

    let viewModel = MyAddressesViewModel()
    let disposeBag = DisposeBag()
//    var selectedAddress: Address?
//    var selectedIndex: Int?
    

    func setupBindings() {
        viewModel.refresh
            .bind { [weak self] _ in
                DispatchQueue.main.async {[weak self] in
                    self?.addressTable.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.havingError.skip(1)
            .bind { [weak self] _ in
                DispatchQueue.main.async {[weak self] in
                    self?.showToast(message: "Can't get addresses")
                }
            }
            .disposed(by: disposeBag)
        
        
        viewModel.addressDeletedSuccessfully.skip(1)
            .bind { [weak self] success in
                if success {
                    DispatchQueue.main.async {[weak self] in
                        self?.addressTable.reloadData()
                        self?.showToast(message: "Address deleted successfully")
                    }
                } else {
                    self?.showRedToast(message: "Can't delete this address")
                }
             
            }
            .disposed(by: disposeBag)
        
        viewModel.defaultAddressSet.skip(1)
            .bind { [weak self] index in
                DispatchQueue.main.async {[weak self] in
                    self?.setDefaultAdress(index: index ?? 0)
                }
            }
            .disposed(by: disposeBag)
    }
    
    
    
    @IBOutlet weak var addressTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
               
        self.title = "Shipping Address"
        self.navigationController?.navigationBar.backgroundColor = .white
        addressTable.delegate = self
        addressTable.dataSource = self
//        addressTable.separatorStyle = .none
        addressTable.register(UINib(nibName: "NewAddressCell", bundle: nil), forCellReuseIdentifier: "NewAddressCell")
        addressTable.reloadData()
        setupBindings()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Update the checkmark accessory on the last added address
        if let selectedIndex = viewModel.selectedIndex {
            if selectedIndex < viewModel.addresses.count {
                viewModel.selectedAddress = viewModel.addresses[selectedIndex]
                addressTable.reloadData()
            }
        }
        
        viewModel.getAddresses()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAddresses()
    }

    func setDefaultAdress(index: Int) {
//            if success {
        viewModel.selectedAddress = viewModel.addresses[index]
        viewModel.selectedIndex = index

                // Save the selected address and index to UserDefaults
        if let encodedAddress = try? JSONEncoder().encode(viewModel.selectedAddress) {
                    UserDefaults.standard.set(encodedAddress, forKey: "SelectedAddress")
                    UserDefaults.standard.set(index, forKey: "SelectedAddressIndex")
                }
            addressTable.reloadData()
        

//                 Update the checkmark for the selected row
//                if let selectedCell = tableView.cellForRow(at: indexPath) {
//                    selectedCell.accessoryType = .checkmark
//                }
//            }
    }
    
    func didAddNewAddress(_ newAddress: Address) {
        viewModel.addresses.append(newAddress)
            viewModel.selectedIndex = viewModel.addresses.count - 1

          addressTable.reloadData()
      }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.addresses.count
        
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let address = viewModel.addresses[indexPath.row]

                viewModel.deleteAddress(address)
        }
    }
  
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewAddressCell", for: indexPath) as! NewAddressCell
        let address = viewModel.addresses[indexPath.row]
        
        let city = address.city ?? " "
        let country = address.address2 ?? ""
        
        let location = "\(city),\(country)."

        cell.addressLabel.text = address.address1
        cell.CityAndCountryLabel.text = location
        cell.phoneLabel.text = address.phone
        if address.isDefault == true {
                cell.accessoryType = .checkmark
                viewModel.selectedIndex = indexPath.row
                viewModel.selectedAddress = address
            } else {
                cell.accessoryType = .none
            }
    return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedAddress = viewModel.addresses[indexPath.row]
        
        if let previousSelectedIndex = viewModel.selectedIndex {
            // Clear the checkmark from the previously selected row
            if let previousSelectedCell = tableView.cellForRow(at: IndexPath(row: previousSelectedIndex, section: 0)) {
                previousSelectedCell.accessoryType = .none
            }
        }
        
        viewModel.setDefaultAddressForCustomer(viewModel.addresses[indexPath.row], index: indexPath.item)
//        setDefaultAddressForCustomer(selectedAddress) { success in
//            if success {
//                self.selectedAddress = selectedAddress
//                self.selectedIndex = indexPath.row
//
//                // Save the selected address and index to UserDefaults
//                if let encodedAddress = try? JSONEncoder().encode(selectedAddress) {
//                    UserDefaults.standard.set(encodedAddress, forKey: "SelectedAddress")
//                    UserDefaults.standard.set(indexPath.row, forKey: "SelectedAddressIndex")
//                }
//
//                // Update the checkmark for the selected row
//                if let selectedCell = tableView.cellForRow(at: indexPath) {
//                    selectedCell.accessoryType = .checkmark
//                }
//            } else {
//                // Handle the case where setting the default address fails
//                // You can show an alert or take appropriate action
//                print("Failed to set the default address.")
//            }
//        }
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        
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
    

//    func setDefaultAddressForCustomer(_ address: Address, completion: @escaping (Bool) -> Void) {
//        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers/7495027327292/addresses/\(address.id ?? 0)/default.json"
//        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
//
//        AF.request(baseURLString, method: .put, headers: headers)
//            .response { response in
//                switch response.result {
//                case .success:
//                    print("Default address set successfully")
//                    completion(true) // Notify success
//
//                case .failure(let error):
//                    print("Failed to set default address. Error: \(error)")
//                    completion(false) // Notify failure
//                }
//            }
//    }
   

}

