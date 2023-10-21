//
//  WishListViewController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/21/23.
//

import UIKit

class WishListViewController: UIViewController {

    @IBOutlet weak var wishListCollectionView: UICollectionView!
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    let mainCategoriesArray = ["All", "Men", "Women", "Kids"]
    let SubCategoriesArray = ["tshirt", "dress", "bag","shoe", "pants"]
    let sortingArray = ["Price", "Popular"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Wishlist"
        

        wishListCollectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
       
        
        self.wishListCollectionView.register( SectionHeader.self, forSupplementaryViewOfKind: BrandViewController.sectionHeaderElementKind, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        wishListCollectionView.delegate = self
        wishListCollectionView.dataSource = self
        
        let layout = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            
           
 
                return self.items()

            
        }
        
        wishListCollectionView.setCollectionViewLayout(layout, animated: true)
        
        
        // Do any additional setup after loading the view.
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
                
            return 10
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
            let cell = wishListCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)

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

    




    



    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


