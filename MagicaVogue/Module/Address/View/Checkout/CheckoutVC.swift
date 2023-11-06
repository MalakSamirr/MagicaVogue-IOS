//
//  CheckoutVC.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 19.10.2023.
//

import UIKit
import Alamofire

class CheckoutVC: ViewController ,  UITableViewDataSource , UITableViewDelegate , UIAdaptivePresentationControllerDelegate, UISheetPresentationControllerDelegate   {
 
    

    @IBOutlet weak var addressTableView: UITableView!
    var discountCodes: [DiscountCode]?
    var address: Address?
    var priceRule: PriceMRuleModel?
    var cart: [DraftOrder] = []
    var productDataArray: [SelectedProduct] = []
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
        getDiscountCodes()
        getPriceRule()
        getAddress()


    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.isUserInteractionEnabled = true

    }
    override func viewWillAppear(_ animated: Bool) {
        self.view.isUserInteractionEnabled = true

        getDiscountCodes()
        getPriceRule()
        getAddress()
        
    }
 
    
    @IBAction func paymentButtonPressed(_ sender: Any) {
        let paymentViewController = PaymentViewController()
        paymentViewController.draftOrderId = cart[0].id
            let nav = UINavigationController(rootViewController: paymentViewController)
            
            nav.modalPresentationStyle = .pageSheet

            if let sheet = nav.presentationController as? UISheetPresentationController {
                sheet.detents = [.medium()]
                sheet.delegate = self
                sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                sheet.largestUndimmedDetentIdentifier = .medium
            }
            

           present(nav, animated: true, completion: nil)

           self.view.isUserInteractionEnabled = false
    }
    func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
        self.view.isUserInteractionEnabled = true
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
            if !cart.isEmpty {
                if let numberOfRows: Int? = cart[0].line_items.count {
                    return numberOfRows ?? 0
                } else {
                    return 0
                }
            } else {
                return 0
            }
            
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
            let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
            
            
            if indexPath.row < cart[0].line_items.count {
                let draftOrder = cart[0].line_items[indexPath.row]
                cell.productNameLabel.text = draftOrder.title
                cell.productPriceLabel.text = draftOrder.price
                cell.setupUI(lineItem: draftOrder)
                cell.minus.isHidden = true
                cell.plus.isHidden = true
                cell.quantityLabel.isHidden = true
                cell.orderTotalLabel.isHidden = false
                cell.orderTotalLabel.text = "Qty: \(draftOrder.quantity)"
               
                let targetProductId = cart[0].line_items[indexPath.row].product_id
                
                if let filteredProduct = productDataArray.first(where: { $0.product.id == targetProductId }) {
                    let imageUrlString = filteredProduct.product.image?.src
                    if let imageUrl = URL(string: imageUrlString ?? "") {
                        print("ewwwwwww \(filteredProduct)")
                        cell.productImageView.kf.setImage(with: imageUrl)
                    }
                    
                    if let filteredVariant = filteredProduct.product.variants?.first(where: {
                        $0.id == cart[0].line_items[indexPath.row].variant_id
                        
                    }) {
                        cell.maxQuantity = Double(filteredVariant.inventory_quantity)
                        cell.inventoryItemId = filteredVariant.inventory_item_id
                        cell.sizeLabel.text = "Details: \(filteredVariant.title ?? "")"
                    }
                } else {
                    
                }
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
                    self.addressTableView.reloadData()
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
    
}
