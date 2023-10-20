//
//  BrandViewController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/19/23.
//

import UIKit

class BrandViewController: UIViewController{
    
    @IBOutlet weak var BrandCollectionViewDetails: UICollectionView!
    
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    let mainCategoriesArray = ["All", "Men", "Women", "Kids"]
    let SubCategoriesArray = ["tshirt", "dress", "bag","shoe", "pants"]
    let sortingArray = ["Price", "Popular"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Pull&Bear"
        

        BrandCollectionViewDetails.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        BrandCollectionViewDetails.register(UINib(nibName: "MainCategoryCell", bundle: nil), forCellWithReuseIdentifier: "MainCategoryCell")
        BrandCollectionViewDetails.register(UINib(nibName: "SubCategoryCell", bundle: nil), forCellWithReuseIdentifier: "SubCategoryCell")
        
        self.BrandCollectionViewDetails.register( SectionHeader.self, forSupplementaryViewOfKind: BrandViewController.sectionHeaderElementKind, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        BrandCollectionViewDetails.delegate = self
        BrandCollectionViewDetails.dataSource = self
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            
            switch sectionIndex {
                
            case 0 :
                
                return self.mainCategories()
                
            case 1 :
                
                return self.subCategories()
                
            case 2:
                
                return self.sortingCategorie()

            default:
                return self.items()
                
                
            }
            
        }
        
        BrandCollectionViewDetails.setCollectionViewLayout(layout, animated: true)
        
        
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
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: BrandViewController.sectionHeaderElementKind, alignment: .top)

        section.boundarySupplementaryItems = [sectionHeader]
        
        
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
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: BrandViewController.sectionHeaderElementKind, alignment: .top)

        section.boundarySupplementaryItems = [sectionHeader]
        
        
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


extension BrandViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return mainCategoriesArray.count
        case 1:
            return SubCategoriesArray.count
        case 2:
            return 2
        case 3:
            return 6
        default:
            return 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = BrandCollectionViewDetails.dequeueReusableCell(withReuseIdentifier: "MainCategoryCell", for: indexPath) as! MainCategoryCell
            
            cell.mainCategoryLabel.text = mainCategoriesArray[indexPath.row]
            return cell
            
        case 1:
            let cell = BrandCollectionViewDetails.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
            cell.subCategoryItemImage.image = UIImage(named: SubCategoriesArray[indexPath.row])
            return cell
        case 2:
            let cell = BrandCollectionViewDetails.dequeueReusableCell(withReuseIdentifier: "MainCategoryCell", for: indexPath) as! MainCategoryCell
            cell.mainCategoryLabel.text = sortingArray[indexPath.row]
            return cell
        case 3:
            let cell = BrandCollectionViewDetails.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
            return cell
        default:
            let cell = BrandCollectionViewDetails.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
            return cell        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        4
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 50) // Adjust the height as needed
    }
    
    // Provide the view for the section header
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderArray: [String] = ["", "", "Sort by:",""]
        
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
        BrandCollectionViewDetails.deselectItem(at: indexPath, animated: true)

        switch indexPath.section {
        case 0:
            if let cell = collectionView.cellForItem(at: indexPath) as? MainCategoryCell {
                // Modify the appearance of the selected cell
                let backgroundColor = UIColor(red: 89/255.0, green: 10/255.0, blue: 4/255.0, alpha: 1.0)
                
                cell.mainCategoryLabel.textColor = .white
                cell.mainCategoryBackgroundView.backgroundColor = backgroundColor
                
                // Reload the selected item to reflect the changes
                collectionView.reloadItems(at: [indexPath])
            }
            
        case 1:
            if let cell = collectionView.cellForItem(at: indexPath) as? SubCategoryCell {
                // Modify the appearance of the selected cell
                let backgroundColor = UIColor(red: 89/255.0, green: 10/255.0, blue: 4/255.0, alpha: 1.0)
                cell.subCategoryBackgroundView.layer.borderWidth = 1.0 // Adjust the border width as needed
                cell.subCategoryBackgroundView.layer.borderColor = backgroundColor.cgColor
            }
            
        case 2:
            if let cell = collectionView.cellForItem(at: indexPath) as? MainCategoryCell {
                // Modify the appearance of the selected cell
                let backgroundColor = UIColor(red: 89/255.0, green: 10/255.0, blue: 4/255.0, alpha: 1.0)
                
                cell.mainCategoryLabel.textColor = .white
                cell.mainCategoryBackgroundView.backgroundColor = backgroundColor
                
                // Reload the selected item to reflect the changes
                collectionView.reloadItems(at: [indexPath])
            }
        default:
            return
            
        }
    }
}
    




    



    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


