//
//  BrandViewController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/19/23.
//

import UIKit
import Kingfisher
import Alamofire


class BrandViewController: UIViewController{
    
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var BrandCollectionViewDetails: UICollectionView!

    var viewModel: BrandViewModel = BrandViewModel()
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    override func viewDidLoad() {
        super.viewDidLoad()
      
        
        self.title = viewModel.brand?.title
        searchBar.frame = CGRect(x: searchBar.frame.origin.x, y: searchBar.frame.origin.y, width: searchBar.frame.size.width, height: 120)
        searchBar.delegate = self
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.BrandCollectionViewDetails.reloadData()
            }
        }
        print(viewModel.productArray)
        
        BrandCollectionViewDetails.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        BrandCollectionViewDetails.register(UINib(nibName: "MainCategoryCell", bundle: nil), forCellWithReuseIdentifier: "MainCategoryCell")
        BrandCollectionViewDetails.register(UINib(nibName: "SubCategoryCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryCell")
        self.BrandCollectionViewDetails.register( SectionHeader.self, forSupplementaryViewOfKind: BrandViewController.sectionHeaderElementKind, withReuseIdentifier: SectionHeader.reuseIdentifier)
        BrandCollectionViewDetails.delegate = self
        BrandCollectionViewDetails.dataSource = self
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            switch sectionIndex {
            case 0:
                return self.sortingCategorie()
            default:
                return self.items()
            }
        }
        BrandCollectionViewDetails.setCollectionViewLayout(layout, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.getWishlist {
            
        }
    }
    
}

// MARK: - Flow layout
extension BrandViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 50) // Adjust the height as needed
    }
}


// MARK: - Delegate
extension BrandViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        BrandCollectionViewDetails.deselectItem(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if let cell = collectionView.cellForItem(at: indexPath) as? MainCategoryCell {
                if let previousSelectedIndexPath = viewModel.selectedIndexPathForSubCategory {
                    if let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? MainCategoryCell {
                        if viewModel.sortArray[indexPath.row].isSelected {
                            previousSelectedCell.isSelected=false
                            viewModel.sortArray[previousSelectedIndexPath.row].isSelected=false
                            viewModel.productArray = viewModel.dataArray
                            BrandCollectionViewDetails.reloadData()
                            return
                        }
                        previousSelectedCell.isSelected = false
                        viewModel.sortArray[previousSelectedIndexPath.row].isSelected = false
                        BrandCollectionViewDetails.reloadData()
                        print(viewModel.sortArray)
                    }
                }
                cell.isSelected = true
                viewModel.sortArray[indexPath.row].isSelected = true
                viewModel.selectedIndexPathForSubCategory = indexPath
                print(viewModel.sortArray)
                viewModel.sortByPrice(id: viewModel.sortArray[indexPath.row].id)
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
            }
                
        default:
            if let product = viewModel.productArray?[indexPath.row]{
                let productDetailsVC = ProductDetailsViewController()
                productDetailsVC.productDetailsViewModel.myProduct = product
                for item in viewModel.wishlist {
                    if item.line_items[0].title == product.title {
                        productDetailsVC.isFavourite = true
                        productDetailsVC.draftOrderId = item.id
                    }
                }
                
                self.navigationController?.pushViewController(productDetailsVC, animated: true)
                
            }
            
        }
    }
}



// MARK: - Data Source
extension BrandViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return viewModel.productArray?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = BrandCollectionViewDetails.dequeueReusableCell(withReuseIdentifier: "MainCategoryCell", for: indexPath) as! MainCategoryCell
            cell.mainCategoryLabel.text = viewModel.sortArray[indexPath.row].name
            if viewModel.sortArray[indexPath.row].isSelected {
                cell.mainCategoryLabel.textColor = .white
                cell.mainCategoryBackgroundView.backgroundColor = UIColor(red: 0.36, green: 0.46, blue: 0.42, alpha: 1.0)
                viewModel.selectedIndexPath = indexPath
            }
            return cell
        case 1:
            let cell = BrandCollectionViewDetails.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
            cell.animationDelegate = self
            if let product = viewModel.productArray?[indexPath.row]{
                if let imageUrl = URL(string: product.image?.src ?? "heart") {
                    cell.brandItemImage.kf.setImage(with: imageUrl)
                } else {
                    cell.brandItemImage.image = UIImage(named: "CouponBackground")
                }
                cell.itemLabel.text = product.title
                
                
                if let intValue = Double(product.variants?[0].price ?? "0") {
                    let userDefaults = UserDefaults.standard
                    let customerID = 7471279866172
                    let CurrencyValue = userDefaults.double(forKey: "CurrencyValue\(customerID)")
                    let CurrencyKey = userDefaults.string(forKey: "CurrencyKey\(customerID)")
                    
                    let result = intValue * CurrencyValue
                        let resultString = String(format: "%.2f", result)
                    cell.itemPrice.text = "\(CurrencyKey ?? "") \(resultString)"
                    }
                    
                
                
                cell.id = product.id
                var isFavorite = false
                for item in viewModel.wishlist {
                    if item.line_items[0].title == product.title {
                        isFavorite = true
                        cell.draftOrder = item.id
                    }
                }
                    cell.favoriteButton?.isSelected = isFavorite
            
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderArray: [String] = ["Price:",""]
        if kind == BrandViewController.sectionHeaderElementKind {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
            headerView.label.text = sectionHeaderArray[indexPath.section]
            return headerView
        }
        return UICollectionReusableView()
    }
}

// MARK: - Layout Functions
extension BrandViewController {
    func sortingCategorie()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 0)
        section.orthogonalScrollingBehavior = .continuous
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: BrandViewController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    func items()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.65))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)
        group.interItemSpacing = .fixed(8)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: BrandViewController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
}

// MARK: - Animation
extension BrandViewController: FavoriteProtocol {
    func deleteFromFavorite(_ itemId: Int) {
        print("hello")
    }
    
    func addToFavorite(_ id: Int) {
        if let product = viewModel.productArray?.first(where: { $0.id == id }) {
            viewModel.myProduct = product
            let baseURLString = "https://ios-q1-new-capital-2023.myshopify.com/admin/api/2023-10/draft_orders.json"
            
            let headers: HTTPHeaders = ["X-Shopify-Access-Token": "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"]
           
            let imageSrc = viewModel.myProduct.image?.src ?? "SHOES"

            // Body data
            let jsonData: [String: Any] = [
                "draft_order": [
                    "note": "Wishlist",
                    "line_items": [
                        [
                            "title": viewModel.myProduct.title ?? "",
                            "price": viewModel.myProduct.variants?[0].price,
                            "quantity": 1,
                        ]
                    ],
                    "applied_discount": [
                        // image saved in api (description)
                        "description": imageSrc,
                        "value_type": "fixed_amount",
                        "value": "10.0",
                        "amount": "10.00",
                        "title": "Custom"
                    ],
                    "customer": [
                        "id": 7471279866172
                    ],
                    "use_customer_default_address": true
                ]
            ]

            AF.request(baseURLString, method: .post, parameters: jsonData, encoding: JSONEncoding.default, headers: headers)
                .response { response in
                    switch response.result {
                    case .success:
                        print("Product added to Wishlist successfully.")
                        self.showSuccessAlert()
                    case .failure(let error):
                        print("Failed to add the product to the Wishlist. Error: \(error)")
                    }
                }
        }
    }

    func showSuccessAlert() {
        let alertController = UIAlertController(
            title: "Success",
            message: "Product added to Wishlist successfully!",
            preferredStyle: .alert
        )
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func playAnimation() {
        viewModel.animationView = .init(name: "favorite")
        // Animation size
        let animationSize = CGSize(width: 200, height: 200)
        viewModel.animationView!.frame = CGRect(x: (view.bounds.width - animationSize.width) / 2, y: (view.bounds.height - animationSize.height) / 2, width: animationSize.width, height: animationSize.height)
        viewModel.animationView!.contentMode = .scaleAspectFit
        viewModel.animationView!.loopMode = .playOnce
        viewModel.animationView!.alpha = 1.0
        view.addSubview(viewModel.animationView!)
        let startTime: CGFloat = 0.1
        let endTime: CGFloat = 0.3
        viewModel.animationView?.play(
            fromProgress: startTime,
            toProgress: endTime
        ) { [weak self] _ in
            self?.viewModel.animationView?.removeFromSuperview()
        }
    }
}

// MARK: - Search
extension BrandViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.productArray = viewModel.dataArray
        } else {
            viewModel.productArray = viewModel.dataArray?.filter { brand in
                if let title = brand.title, title.lowercased().contains(searchText.lowercased()) {
                    return true
                }
                return false
            }
        }
        DispatchQueue.main.async {
            self.BrandCollectionViewDetails.reloadData()
        }
    }
}
