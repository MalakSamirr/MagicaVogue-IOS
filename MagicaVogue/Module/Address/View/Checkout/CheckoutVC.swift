//
//  CheckoutVC.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 19.10.2023.
//

import UIKit

class CheckoutVC: ViewController ,  UITableViewDataSource , UITableViewDelegate {
 
    

    @IBOutlet weak var addressTableView: UITableView!
      
       
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Checkout"
        self.navigationController?.navigationBar.backgroundColor = .white
        addressTableView.delegate = self
        addressTableView.dataSource = self
        addressTableView.register(UINib(nibName: "MyAddressesCell", bundle: nil), forCellReuseIdentifier: "MyAddressesCell")
        addressTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
    }
    
    @IBAction func paymentButtonPressed(_ sender: Any) {
        let paymentViewController = PaymentViewController()
            
            let nav = UINavigationController(rootViewController: paymentViewController)
            
            nav.modalPresentationStyle = .pageSheet

            if let sheet = nav.presentationController as? UISheetPresentationController {
                sheet.detents = [.medium()]
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.largestUndimmedDetentIdentifier = .medium
            }
            
            present(nav, animated: true, completion: nil)
    }
    // MARK: - TABLE VIEW FUNCTIONS
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyAddressesCell", for: indexPath) as! MyAddressesCell
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
            cell.minus.isHidden = true
            cell.plus.isHidden = true
            cell.quantityLabel.isHidden = true
            return cell
        }
    }
    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let headerView = UIView()
//        
//        let headerLabel = UILabel()
//        headerLabel.font = UIFont.boldSystemFont(ofSize: 17)
//        headerLabel.text = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
//        
//        headerView.addSubview(headerLabel)
//        headerLabel.translatesAutoresizingMaskIntoConstraints = false
//        
//        let inset: CGFloat = 20.0
//        let leftConstraint = headerLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: inset)
//        leftConstraint.isActive = true
//        
//        return headerView
//    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Shipping Address"
        } else if section == 1 {
            return "Order List"
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 90
        } else {
            return 120
        }
    }
    
}
