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
                    DispatchQueue.main.async { [weak self] in
                        self?.showDeleteAddressAlert { shouldDelete in
                            if shouldDelete {
                                self?.addressTable.reloadData()
                                self?.showToast(message: "Address deleted successfully")
                            }
                        }
                    }
                } else {
                    self?.showRedToast(message: "Can't delete this address")
                }
                
            }
            .disposed(by: disposeBag)
        
        viewModel.defaultAddressSet.skip(1)
            .bind { [weak self] index in
                DispatchQueue.main.async {[weak self] in
                    
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
        if let previousSelectedIndex = viewModel.selectedIndex {
            
            if let previousSelectedCell = tableView.cellForRow(at: IndexPath(row: previousSelectedIndex, section: 0)) {
                previousSelectedCell.accessoryType = .none
            }
        }
        
        viewModel.setDefaultAddressForCustomer(viewModel.addresses[indexPath.row], index: indexPath.item)
        viewModel.selectedAddress = viewModel.selectedAddress
        viewModel.selectedIndex = indexPath.row
        
        if let encodedAddress = try? JSONEncoder().encode(viewModel.selectedAddress) {
            UserDefaults.standard.set(encodedAddress, forKey: "SelectedAddress")
            UserDefaults.standard.set(indexPath.row, forKey: "SelectedAddressIndex")
        }
        
        if let selectedCell = tableView.cellForRow(at: indexPath) {
            selectedCell.accessoryType = .checkmark
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
    func showNoAddressesFoundMessage() {
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
    func showDeleteAddressAlert(completion: @escaping (Bool) -> Void) {
        let alert = UIAlertController(
            title: "Delete Address",
            message: "Are you sure you want to delete this address?",
            preferredStyle: .alert
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            completion(true)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func addNewAddress(_ sender: UIButton) {
        
        let addVC = ShippingDetailsVC()
        navigationController?.pushViewController(addVC, animated: true)
        
    }
    
    
    
}

