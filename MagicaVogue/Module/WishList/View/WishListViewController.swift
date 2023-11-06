//
//  WishListViewController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/21/23.
//

import UIKit
import Firebase
import FirebaseAuth
import RxCocoa
import RxSwift

class WishListViewController: UIViewController {
    let viewModel = WishlistViewModel()
    let disposeBag = DisposeBag()

    @IBOutlet weak var emptyImage: UIImageView!
    @IBOutlet weak var wishListCollectionView: UICollectionView!
        override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Wishlist"
        self.navigationController?.isNavigationBarHidden = false
        wishListCollectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
               self.wishListCollectionView.register( SectionHeader.self, forSupplementaryViewOfKind: BrandViewController.sectionHeaderElementKind, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        wishListCollectionView.delegate = self
        wishListCollectionView.dataSource = self
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            return self.items()
        }
        wishListCollectionView.setCollectionViewLayout(layout, animated: true)
        setupBindings()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

      if (Auth.auth().currentUser == nil) {
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
          else {
              viewModel.getWishlist()

          }
    }
    func checkFavoriteItems() {
        if viewModel.wishlist.isEmpty {
               
               emptyImage.isHidden = false
            wishListCollectionView.isHidden = true
           } else {
            
               emptyImage.isHidden = true
               wishListCollectionView.isHidden = false
           }
       }
    
    func setupBindings() {
        viewModel.refresh
            .bind { [weak self] _ in
                DispatchQueue.main.async {[weak self] in
                    self?.wishListCollectionView.reloadData()
                    self?.checkFavoriteItems()

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
    
 
    func items()-> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5)
                                              
                                              , heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
                                               
                                               , heightDimension: .fractionalWidth(0.65))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        group.interItemSpacing = .fixed(8)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10
                                                      
                                                      , bottom: 0, trailing: 10)
        
        
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5
                                                        
                                                        , bottom: 0, trailing: 5)
        
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: BrandViewController.sectionHeaderElementKind, alignment: .top)

        section.boundarySupplementaryItems = [sectionHeader]
        
        // section.boundarySupplementaryItems = [self.supplementtryHeader()]

        return section
        
    }
    
}


extension WishListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.wishlist.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        let draftOrder = viewModel.wishlist[indexPath.row]
        
        if let lineItem = draftOrder.line_items.first, !lineItem.title.isEmpty {
            cell.itemLabel.text = lineItem.title
            
            if let intValue = Double(lineItem.price ?? "0") {
                let userDefaults = UserDefaults.standard
                let customerID = userDefaults.integer(forKey: "customerID")
                let CurrencyValue = userDefaults.double(forKey: "CurrencyValue\(customerID)")
                let CurrencyKey = userDefaults.string(forKey: "CurrencyKey\(customerID)")
                
                let result = intValue * CurrencyValue
                let resultString = String(format: "%.2f", result)
                cell.itemPrice.text = "\(CurrencyKey ?? "") \(resultString)"
                
            }
            
        } else {
            cell.itemLabel.text = "Product Name Not Available"
        }
        
        // Use Kingfisher to load an image. Replace 'imageUrl' with the appropriate URL.
        if let imageUrl = URL(string: draftOrder.applied_discount.description) {
            cell.brandItemImage.kf.setImage(with: imageUrl)
        } else {
            cell.brandItemImage.image = UIImage(named: "CouponBackground")
        }
        cell.id = viewModel.wishlist[indexPath.item].id
        cell.animationDelegate = self
        cell.favoriteButton?.isSelected = true

        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 50) // Adjust the height as needed
    }
    // Provide the view for the section header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderArray: [String] = [""]
        
        if kind == BrandViewController.sectionHeaderElementKind {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
            // Customize the header view, for example, setting the title
            headerView.label.text = sectionHeaderArray[indexPath.section]
            
            return headerView
        }
        // Return an empty view for other kinds (e.g., footer)
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        return
        
    }
}
  
 
extension WishListViewController: FavoriteProtocol {
    func playAnimation() {}
    
    func addToFavorite(_ id: Int) {}
    
    func deleteFromFavorite(_ itemId: Int) {
        viewModel.deleteDraftOrder(draftOrderId: itemId)
   }
}
