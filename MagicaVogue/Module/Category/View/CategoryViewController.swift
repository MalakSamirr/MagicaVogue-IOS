//
//  CategoryViewController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/20/23.
//

import UIKit
import Alamofire
class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryCollectionView: UICollectionView!
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    let mainCategoriesArray = ["All", "Men", "Women", "Kids"]
    let SubCategoriesArray = ["tshirt", "dress", "bag","shoe", "pants"]
    let sortingArray = ["Price", "Popular"]
    var productArray: [Products]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchBrands()
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
            return mainCategoriesArray.count
        case 1:
            return SubCategoriesArray.count
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
            
            cell.mainCategoryLabel.text = mainCategoriesArray[indexPath.row]
            return cell
            
        case 1:
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
            cell.subCategoryItemImage.image = UIImage(named: SubCategoriesArray[indexPath.row])
            return cell
            
        case 2:
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
            if let product = productArray?[indexPath.row], let imageUrl = URL(string: product.image?.src ?? "heart") {
                
                cell.brandItemImage.kf.setImage(with: imageUrl)
                } else {
                    // Handle the case when the image URL is invalid or missing
                    cell.brandItemImage.image = UIImage(named: "CouponBackground")
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
                let backgroundColor = UIColor(red: 0.36, green: 0.46, blue:0.42, alpha: 1.0)
                
//                cell.mainCategoryLabel.textColor = .white
//                cell.mainCategoryBackgroundView.backgroundColor = backgroundColor
//                print(cell.mainCategoryLabel.text)
//
//                
//                // Reload the selected item to reflect the changes
//                collectionView.reloadData()
            }
            
        case 1:
            if let cell = collectionView.cellForItem(at: indexPath) as? SubCategoryCell {
                // Modify the appearance of the selected cell
                let backgroundColor = UIColor(red: 0.36, green: 0.46, blue:0.42, alpha: 1.0)
                cell.subCategoryBackgroundView.layer.borderWidth = 1.0 // Adjust the border width as needed
                cell.subCategoryBackgroundView.layer.borderColor = backgroundColor.cgColor
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
    
    
    
}
    

