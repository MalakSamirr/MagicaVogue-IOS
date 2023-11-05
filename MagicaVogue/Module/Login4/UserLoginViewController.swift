//
//  UserLoginViewController.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 25.10.2023.
//
import UIKit
import Firebase
import FirebaseAuth
import RxCocoa
import RxSwift

class UserLoginViewController: UIViewController, UICollectionViewDataSource , UITableViewDelegate ,UITableViewDataSource {
    @IBOutlet weak var helloUserLabel: UILabel!
    
    @IBOutlet weak var loginOrdersTableView: UITableView!
    @IBOutlet weak var profileWishlisCollectionView: UICollectionView!
    var viewModel = UserLoginViewModel()
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        profileWishlisCollectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        loginOrdersTableView.register(UINib(nibName: "OrderProfileTableVC", bundle: nil), forCellReuseIdentifier: "OrderProfileTableVC")
        
        profileWishlisCollectionView.dataSource = self
        loginOrdersTableView.dataSource = self
        loginOrdersTableView.delegate = self
        loginOrdersTableView.reloadData()
        profileWishlisCollectionView.reloadData()
        
        // Configure the layout for your profileWishlistViewController
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            return self.items()
        }
        
        profileWishlisCollectionView.setCollectionViewLayout(layout, animated: true)
        setupBindings()
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
            viewModel.getCart()
            viewModel.getWishlist()
            let userDefaults = UserDefaults.standard
            let customerName = userDefaults.string(forKey: "customerName")
            if let firstSpaceIndex = customerName?.firstIndex(of: " ") {
                let firstName = customerName?[..<firstSpaceIndex]
                print(firstName) // This will print "malak"
               helloUserLabel.text = "Hello, \(firstName ?? "") 🫶"
                 
                
                
            }

        }
    }
    
    func setupBindings() {
        viewModel.refreshOrdersTableView
            .bind { [weak self] _ in
                DispatchQueue.main.async {[weak self] in
                    self?.loginOrdersTableView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.refreshWishlistCollectionView
            .bind { [weak self] _ in
                DispatchQueue.main.async {[weak self] in
                    self?.profileWishlisCollectionView.reloadData()
                }
            }
            .disposed(by: disposeBag)
        
        viewModel.havingError.skip(1)
            .bind { [weak self] error in
                DispatchQueue.main.async {[weak self] in
                    self?.showToast(message: error ?? "error")
                }
            }
            .disposed(by: disposeBag)
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
        
        ordersVC.cart = viewModel.cart
        
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
        let draftOrder = viewModel.wishlist[indexPath.row]
        
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
        
        cell.id = viewModel.wishlist[indexPath.item].id
        
        return cell
    }
  
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(4, viewModel.wishlist.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 50) // Adjust the height as needed
    }
    
    // MARK: - loginOrdersTableView Methods
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderProfileTableVC", for: indexPath) as! OrderProfileTableVC
        
        let draftOrder = viewModel.cart[indexPath.row]
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
        return min(2, viewModel.cart.count)
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
   
