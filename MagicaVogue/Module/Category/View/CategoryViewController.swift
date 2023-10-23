//
//  CategoryViewController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/20/23.
//

import UIKit
import Alamofire
class CategoryViewController: UIViewController {
    var selectedIndexPath: IndexPath?
    let mainCategoryArray: [mainCategoryModel] = [mainCategoryModel(name: "All", isSelected: true, imageName: nil), mainCategoryModel(name: "Men", isSelected: false, imageName: nil),mainCategoryModel(name: "Women", isSelected: false, imageName: nil), mainCategoryModel(name: "Kids", isSelected: false, imageName: nil)
    ]
    
    var subCategoryArray: [SubCategoryModel] = [SubCategoryModel(type: "All", isSelected: true), SubCategoryModel(type: "T-SHIRTS", isSelected: false), SubCategoryModel(type: "dress", isSelected: false), SubCategoryModel(type: "ACCESSORIES", isSelected: false), SubCategoryModel(type: "SHOES", isSelected: false), SubCategoryModel(type: "pants", isSelected: false)
        ]
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    static let sectionHeaderElementKind = "section-header-element-kind"
    var selectedIndexPathForSubCategory: IndexPath?
    let mainCategoriesArray = ["All", "Men", "Women", "Kids"]
    let SubCategoriesArray = ["T-SHIRTS", "dress", "ACCESSORIES","SHOES", "pants"]
    let sortingArray = ["Price", "Popular"]
    var productArray: [Products]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBrands()
        
  

            // Assuming collectionView is your UICollectionView instance
       
        

        
        let logoImageView = UIImageView(image: UIImage(named: "Logo"))
        logoImageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = logoImageView
        

        categoryCollectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        categoryCollectionView.register(UINib(nibName: "MainCategoryCell", bundle: nil), forCellWithReuseIdentifier: "MainCategoryCell")
        categoryCollectionView.register(UINib(nibName: "SubCategoryCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryCell")
        
        self.categoryCollectionView.register( SectionHeader.self, forSupplementaryViewOfKind: BrandViewController.sectionHeaderElementKind, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            
            switch sectionIndex {
                
            case 0 :
                
                return self.mainCategories()
                
            case 1 :
                
                return self.subCategories()

            default:
                return self.items()
                
                
            }
            
        }
        
        categoryCollectionView.setCollectionViewLayout(layout, animated: true)
        let indexPath = IndexPath(item: 0, section: 0)

            // Ensure the collectionView is not nil before attempting to select an item
           
        

        // Do any additional setup after loading the view.
    }
    
    
    
    func mainCategories()-> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
                                              
                                              , heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100)
                                               
                                               , heightDimension: .absolute(50))
        
        
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize
                                                       
                                                       , subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
                                                      
                                                      , bottom: 0, trailing: 0)
        
        
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10
                                                        
                                                        , bottom: 0, trailing: 10)
        
        section.orthogonalScrollingBehavior = .continuous
        
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: BrandViewController.sectionHeaderElementKind, alignment: .top)

        section.boundarySupplementaryItems = [sectionHeader]
        
        // section.boundarySupplementaryItems = [self.supplementtryHeader()]
        
        
        return section
        
    }
    
    
    func subCategories()->NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
                                              
                                              , heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(70)
                                               
                                               , heightDimension: .absolute(70))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize
                                                       
                                                       , subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
                                                      
                                                      , bottom: 0, trailing: 0)
        
        
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10
                                                        
                                                        , bottom: 0, trailing: 10)
        
        section.orthogonalScrollingBehavior = .continuous
        
        // section.boundarySupplementaryItems = [self.supplementtryHeader()]
       
        
        
        return section
        
    }
    
    
    
    func sortingCategorie()-> NSCollectionLayoutSection {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1)
                                              
                                              , heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100)
                                               
                                               , heightDimension: .absolute(50))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize
                                                       
                                                       , subitems: [item])
        
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0
                                                      
                                                      , bottom: 0, trailing: 0)
        
        
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5
                                                        
                                                        , bottom: 0, trailing: 0)
        
        section.orthogonalScrollingBehavior = .continuous
        
        // section.boundarySupplementaryItems = [self.supplementtryHeader()]
        
        
        
        return section
        
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


extension CategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return mainCategoryArray.count
        case 1:
            return subCategoryArray.count
        case 2:
            return productArray?.count ?? 0

        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "MainCategoryCell", for: indexPath) as! MainCategoryCell
            
            cell.mainCategoryLabel.text = mainCategoryArray[indexPath.row].name
            
            if mainCategoryArray[indexPath.row].isSelected {
                cell.mainCategoryLabel.textColor = .white
                cell.mainCategoryBackgroundView.backgroundColor = UIColor(red: 0.36, green: 0.46, blue: 0.42, alpha: 1.0)
                selectedIndexPath = indexPath
            }
            return cell
            
        case 1:
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
            cell.subCategoryItemImage.image = UIImage(named: subCategoryArray[indexPath.row].type ?? "")
            if subCategoryArray[indexPath.row].isSelected ?? false {
                cell.subCategoryBackgroundView.layer.borderWidth = 1.0 // Adjust the border width as needed
                cell.subCategoryBackgroundView.layer.borderColor = UIColor(red: 0.36, green: 0.46, blue:0.42, alpha: 1.0).cgColor
                selectedIndexPathForSubCategory = indexPath
            }
            
            return cell
            
        case 2:
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
            if let product = productArray?[indexPath.row]{
                
                if let imageUrl = URL(string: product.image?.src ?? "heart") {
                    
                    cell.brandItemImage.kf.setImage(with: imageUrl)
                } else {
                    // Handle the case when the image URL is invalid or missing
                    cell.brandItemImage.image = UIImage(named: "CouponBackground")
                }
                cell.itemLabel.text = product.title
                
            }
            // cell.brandItemImage.image
            return cell
        default:
            
            return UICollectionViewCell()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 5, height: 0) // Adjust the height as needed
    }
    
    // Provide the view for the section header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderArray: [String] = ["", "", "",""]
        
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
        categoryCollectionView.deselectItem(at: indexPath, animated: true)

        switch indexPath.section {
        case 0:
            if let cell = collectionView.cellForItem(at: indexPath) as? MainCategoryCell {
                // Modify the appearance of the selected cell
                if let previousSelectedIndexPath = selectedIndexPath {
                            if let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? MainCategoryCell {
                                previousSelectedCell.isSelected = false
                               
                            }
                        }
                        
                        // Select the new cell
                        cell.isSelected = true
                print(cell.mainCategoryLabel.text)
               
                        // Update the selectedIndexPath
                        selectedIndexPath = indexPath


            }
            
        case 1:
            if let cell = collectionView.cellForItem(at: indexPath) as? SubCategoryCell {
                // Modify the appearance of the selected cell
                if let previousSelectedIndexPath = selectedIndexPathForSubCategory {
                            if let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? SubCategoryCell {
                                previousSelectedCell.isSelected = false
                                subCategoryArray[previousSelectedIndexPath.row].isSelected = false
                            }
                        }
                        
                        // Select the new cell
                        cell.isSelected = true
                subCategoryArray[indexPath.row].isSelected = true
               // print(cell.s.text)
                        // Update the selectedIndexPath
                        selectedIndexPathForSubCategory = indexPath
                if indexPath.row < SubCategoriesArray.count {
                    filterProducts(byProductType: subCategoryArray[indexPath.row].type ?? "")
                    print(SubCategoriesArray[indexPath.row])
                }
                            }
            
        
        default:
            return
            
        }
    }
    
    func fetchBrands() {
        let url = "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json"

        AF.request(url, method: .get)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success:
                    if let data = response.data {
                        // Convert data to a string for printing
                        if let jsonString = String(data: data, encoding: .utf8) {
                            
                        }
                        do {
                            let decoder = JSONDecoder()
                            let apiResponse = try decoder.decode(Product.self, from: data)
                            
                            // print(apiResponse)
                            self.productArray = apiResponse.products
                            print(self.productArray)
                            
                            DispatchQueue.main.async {
                                self.categoryCollectionView.reloadData()
                            }
                            } catch {
                                print("Error decoding JSON: \(error)")
                                                // Handle the decoding error as needed.
                                            }
                        
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                    // Handle the request failure as needed.
                }
            }
    }
    func filterProducts(byProductType productTypeToFilter: String) {
        // Filter products based on the provided product type
        productArray = self.productArray?.filter { product in
            return product.product_type == productTypeToFilter
        }
        
        // Reload the collection view with the filtered products
        DispatchQueue.main.async {
            self.categoryCollectionView.reloadData()
        }
    }

    
    
}
    

