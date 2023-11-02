//
//  UserLoginViewController.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 25.10.2023.
//
import UIKit
import Firebase
import FirebaseAuth

class UserLoginViewController: UIViewController, UICollectionViewDataSource , UITableViewDelegate ,UITableViewDataSource {
    
    @IBOutlet weak var loginOrdersTableView: UITableView!
    @IBOutlet weak var profileWishlistViewController: UICollectionView!
    var cart: [DraftOrder] = []
    var wishlist: [DraftOrder] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        profileWishlistViewController.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        loginOrdersTableView.register(UINib(nibName: "OrderProfileTableVC", bundle: nil), forCellReuseIdentifier: "OrderProfileTableVC")
        
        profileWishlistViewController.dataSource = self
        loginOrdersTableView.dataSource = self
        loginOrdersTableView.delegate = self
        print("hebbbbba\(cart)")
        getCart()
        getWishlist()
        loginOrdersTableView.reloadData()
        profileWishlistViewController.reloadData()
        
        // Configure the layout for your profileWishlistViewController
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            return self.items()
        }
        
        profileWishlistViewController.setCollectionViewLayout(layout, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
            if (Auth.auth().currentUser == nil){
                let alert1 = UIAlertController(
                    title: "Login first", message: "you should login you account first!", preferredStyle: UIAlertController.Style.alert)
                
                let loginAction = UIAlertAction(title: "Login Now" , style : .default) { (action) in
                    
                    if let sceneDelegate = UIApplication.shared.connectedScenes
                                .first?.delegate as? SceneDelegate {
                                sceneDelegate.resetAppNavigation()
                            }
                }
            
            
            alert1.addAction(loginAction)
            
            
            present(alert1, animated: true , completion: nil)
            
            
            return
        
            }
        else{
            getCart()
            getWishlist()
        }
    }
    
    
    
    
    
    
    
    
    func items() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.65))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        
        group.interItemSpacing = .fixed(8)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 8 // Spacing between groups
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        section.orthogonalScrollingBehavior = .continuous
        
        return section
    }
    
    
    @IBAction func moreOrdersButtonPressed(_ sender: Any) {
        let ordersVC = OrderViewController()
        
        ordersVC.cart = self.cart
        
        navigationController?.pushViewController(ordersVC, animated: true)
    }
    
    @IBAction func moreWishlistButtonPressed(_ sender: Any) {
        let wishlistVC = WishListViewController()
        
        navigationController?.pushViewController(wishlistVC, animated: true)
    }
    
    @IBAction func SettingsButton(_ sender: Any) {
        
        let settingsvc = SettingsTableViewController()
        self.navigationController?.pushViewController(settingsvc, animated: true)
    }
    
    // MARK: - profileWishlistViewController Methods
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let draftOrder = wishlist[indexPath.row]
        
        if let lineItem = draftOrder.line_items.first, !lineItem.title.isEmpty {
            cell.itemLabel.text = lineItem.title
        } else {
            cell.itemLabel.text = "Product Name Not Available"
        }
        
        // Use Kingfisher to load an image. Replace 'imageUrl' with the appropriate URL.
        if let imageUrl = URL(string: draftOrder.applied_discount.description) {
            cell.brandItemImage.kf.setImage(with: imageUrl)
        } else {
            cell.brandItemImage.image = UIImage(named: "CouponBackground")
        }
        cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        
        cell.id = wishlist[indexPath.item].id
        
        return cell
    }
    func getWishlist() {
        if APIManager.shared.isOnline() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json") { (result: Result<DraftOrderResponse, Error>) in
                switch result {
                case .success(let draftOrderResponse):
                    // Filter draft orders with note: "Wishlist"
                    self.wishlist = draftOrderResponse.draft_orders.filter { $0.note == "Wishlist" }
                    DispatchQueue.main.async {
                        self.profileWishlistViewController.reloadData()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        } else {
            print("Not connected")
        }
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, wishlist.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 50) // Adjust the height as needed
    }
    
    // MARK: - loginOrdersTableView Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderProfileTableVC", for: indexPath) as! OrderProfileTableVC
        
        let draftOrder = cart[indexPath.row]
        //            if let lineItem = draftOrder.line_items.first, !lineItem.title.isEmpty {
        //                cell.productNameLabel.text = lineItem.title
        //                cell.quantityLabel.isHidden = true
        //                cell.sizeLabel.text = "Size:XL || Qty:\(lineItem.quantity)"
        //                cell.productPriceLabel.text = lineItem.price
        //                cell.minus.isHidden = true
        //                cell.plus.isHidden = true
        //
        //
        //            } else {
        //                cell.productNameLabel.text = "Product Name Not Available"
        //            }
        //        if let imageUrl = URL(string: draftOrder.applied_discount.description) {
        //            cell.productImageView.kf.setImage(with: imageUrl)
        //        } else {
        //            cell.productImageView.image = UIImage(named: "CouponBackground")
        //        }
        
        cell.createdAttLabel.text = formatDate(draftOrder.created_at ?? " ")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(2, cart.count)
    }
    
    func getCart() {
        if APIManager.shared.isOnline() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json") { [self] (result: Result<DraftOrderResponse, Error>) in
                switch result {
                case .success(let draftOrderResponse):
                    // Filter draft orders with note: "cart"
                    self.cart = draftOrderResponse.draft_orders.filter { $0.note == "cart" }
                    
                    // Reload the data in the loginOrdersTableView
                    DispatchQueue.main.async {
                        self.loginOrdersTableView.reloadData()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        } else {
            print("Not connected")
        }
    }
  
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM d, yyyy, h:mm a"
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            return outputFormatter.string(from: date)
        }
        
        return dateString // Return the original string if date parsing fails.
    }
}

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = loginOrdersTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell else { return UITableViewCell() }
//        cell.minus.isHidden = true
//        cell.plus.isHidden = true
//        cell.quantityLabel.isHidden = true
//        cell.sizeLabel.text = "Size:XL || Qty:13"
//        cell.productPriceLabel.isHidden = true
//        cell.orderTotalLabel.isHidden = false
//        cell.sizeLabel.textColor = .systemGray
//        return cell
        
     
        
//    }
   
