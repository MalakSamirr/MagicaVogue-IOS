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
        addressTableView.register(UINib(nibName: "PromoCodeCell", bundle: nil), forCellReuseIdentifier: "PromoCodeCell")
        addressTableView.separatorStyle = UITableViewCell.SeparatorStyle.none

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
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        case 2:
            return 1
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyAddressesCell", for: indexPath) as! MyAddressesCell
                return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
            cell.minus.isHidden = true
            cell.plus.isHidden = true
            cell.quantityLabel.isHidden = true
            cell.orderTotalLabel.isHidden = false
            cell.productPriceLabel.isHidden = true
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCodeCell", for: indexPath) as! PromoCodeCell
            return cell
        default:
            return UITableViewCell()

            
            
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
        switch section {
        case 0:
            return "Shipping Address"
        case 1:
            return "Order list"
        case 2:
            return "Promocode"
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.section {
        case 0:
            return 90
        case 1:
            return 120
        case 2:
            return 300
            
        default:
            return 0
        }
    }
    
}
