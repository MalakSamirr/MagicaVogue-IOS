//
//  WishListViewController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/21/23.
//

import UIKit
import Alamofire

class WishListViewController: UIViewController {

    @IBOutlet weak var wishListCollectionView: UICollectionView!
    var wishlist: [DraftOrder] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Wishlist"
        self.navigationController?.isNavigationBarHidden = false
        

        wishListCollectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
       
        
        self.wishListCollectionView.register( SectionHeader.self, forSupplementaryViewOfKind: BrandViewController.sectionHeaderElementKind, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        wishListCollectionView.delegate = self
        wishListCollectionView.dataSource = self
        getWishlist()
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            
           
 
                return self.items()

            
        }
        
        wishListCollectionView.setCollectionViewLayout(layout, animated: true)
        
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getWishlist()
        print(wishlist)
    }
  
    func deleteDraftOrder(draftOrderId: Int) {
        // Your Shopify API URL
        let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders/\(draftOrderId).json"
        
        // Request headers
        let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
        
        AF.request(baseURLString, method: .delete, headers: headers)
            .response { response in
                switch response.result {
                case .success:
                    // Successfully deleted the Draft Order
                    print("Draft Order with ID \(draftOrderId) deleted successfully.")
                    
                    // Update the local data source (remove the deleted item)
                    if let index = self.wishlist.firstIndex(where: { $0.id == draftOrderId }) {
                        self.wishlist.remove(at: index)
                    }
                    
                    // Reload the table view data outside the response block
                    DispatchQueue.main.async {
                        self.wishListCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("Failed to delete Draft Order with ID \(draftOrderId). Error: \(error)")
                }
            }
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
        return wishlist.count
    }
    
    
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
        cell.id = wishlist[indexPath.item].id
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
 

    
    func getWishlist() {
        if APIManager.shared.isOnline() {
            APIManager.shared.request(.get, "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json") { (result: Result<DraftOrderResponse, Error>) in
                switch result {
                case .success(let draftOrderResponse):
                    // Filter draft orders with note: "Wishlist"
                    self.wishlist = draftOrderResponse.draft_orders.filter { $0.note == "Wishlist" }
                    DispatchQueue.main.async {
                        self.wishListCollectionView.reloadData()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        } else {
            print("Not connected")
        }
    }
    
    
    
}
  
 
extension WishListViewController: FavoriteProtocol {
    func playAnimation() {}
    
    func addToFavorite(_ id: Int) {}
    
    func deleteFromFavorite(_ itemId: Int) {
        deleteDraftOrder(draftOrderId: itemId)
        }
}
