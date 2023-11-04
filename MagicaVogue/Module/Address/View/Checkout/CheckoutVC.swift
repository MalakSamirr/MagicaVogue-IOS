//
//  CheckoutVC.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 19.10.2023.
//

import UIKit
import Alamofire

class CheckoutVC: ViewController ,  UITableViewDataSource , UITableViewDelegate {
 
    

    @IBOutlet weak var addressTableView: UITableView!
    var discountCodes: [DiscountCode]?
    var address: Address?
    var priceRule: PriceMRuleModel?
    var cart: [DraftOrder] = []
    var totalPrice : Double = 0.0
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
        
//        print("cartttttttt\(cart)")
        getDiscountCodes()
        getPriceRule()
        getAddress()


    }
    override func viewWillAppear(_ animated: Bool) {
        getDiscountCodes()
        getPriceRule()
        getAddress()
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
            return address != nil ? 1 : 0
        case 1:
            return cart.count
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
                       cell.addressDelegate = self

                       if let address = self.address {
                           let address11 = address.address1 ?? ""
                           let city = address.city ?? ""
                           let location = "\(address11), \(city)"

                           cell.addressLabel.text = address.address2 //Egypt
                           cell.countryLabel.text = location
                       }
                       return cell
      
        case 1:
//            let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
//            cell.minus.isHidden = true
//            cell.plus.isHidden = true
//            cell.quantityLabel.isHidden = true
//            cell.orderTotalLabel.isHidden = false
//            cell.productPriceLabel.isHidden = true
//
//            return cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
                           
                let draftOrder = cart[indexPath.row]
                if let lineItem = draftOrder.line_items.first, !lineItem.title.isEmpty {
                    cell.productNameLabel.text = lineItem.title
                    cell.quantityLabel.isHidden = true
                    cell.sizeLabel.text = "Size:XL || Qty:\(lineItem.quantity)"
                    cell.productPriceLabel.text = lineItem.price
                    cell.minus.isHidden = true
                    cell.plus.isHidden = true
                    

                } else {
                    cell.productNameLabel.text = "Product Name Not Available"
                }
            if let imageUrl = URL(string: draftOrder.applied_discount.description) {
                cell.productImageView.kf.setImage(with: imageUrl)
            } else {
                cell.productImageView.image = UIImage(named: "CouponBackground")
            }
                return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "PromoCodeCell", for: indexPath) as! PromoCodeCell
            cell.totalPriceLabel.text = String(totalPrice)
            if cell.Discount.text != "0%" {
                let price = Double( cell.totalPriceLabel.text ?? "0" ) ?? 0
                let PriceAfterDiscount = price*0.9
                cell.priceAfterDiscount.text = String(PriceAfterDiscount)
            }
            cell.priceAfterDiscount.text = String(totalPrice)
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
    func getAddress() {
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/customers/7495027327292/addresses.json"
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]

        AF.request(baseURLString, method: .get, encoding: JSONEncoding.default, headers: headers)
            .responseDecodable(of: Customer.self) { response in
                switch response.result {
                case .success(let customer):
                    if let defaultAddress = customer.addresses?.first(where: { $0.isDefault == true }) {
                        self.address = defaultAddress
                        DispatchQueue.main.async {
                            self.addressTableView.reloadData()
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

extension CheckoutVC: AddressProtocol {
    func NavigateToAddress() {
        let myAddressesVC = MyAddressesVC()
        navigationController?.pushViewController(myAddressesVC, animated: true)
    }
    
    func getDiscountCodes() {
        APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com//admin/api/2023-10/price_rules/1405087318332/discount_codes.json") { (result: Result<CouponModel, Error>) in
            print(result)
            switch result {
            case .success(let couponModel):
                self.discountCodes = couponModel.discount_codes
                DispatchQueue.main.async {
                    // Notify the view that data has been updated
                    print(self.discountCodes)

                    self.addressTableView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
    func getPriceRule() {
        APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com//admin/api/2023-10/price_rules/1405087318332.json") { (result: Result<PriceMRuleModel, Error>) in
            switch result {
            case .success(let priceRule):
                self.priceRule = priceRule
                DispatchQueue.main.async {
                    // Notify the view that data has been updated
                    print(self.priceRule)
                    self.addressTableView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
}
