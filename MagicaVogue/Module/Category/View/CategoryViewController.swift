//
//  CategoryViewController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/20/23.
//

import UIKit
import Alamofire
import Lottie

class CategoryViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    // MARK: - Variables
    var viewModel: CategoryViewModel = CategoryViewModel()
    static let sectionHeaderElementKind = "section-header-element-kind"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.onDataUpdate = { [weak self] in
                DispatchQueue.main.async {
                    self?.categoryCollectionView.reloadData()
                }
            }
        viewModel.getCategories(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json")

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
            case 0:
                return self.mainCategories()
            case 1:
                return self.subCategories()
            default:
                return self.items()
            }
        }
        categoryCollectionView.setCollectionViewLayout(layout, animated: true)
        let indexPath = IndexPath(item: 0, section: 0)
    }
}


// MARK: - Data Source
extension CategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.mainCategoryArray.count
        case 1:
            return viewModel.subCategoryArray.count
        case 2:
            print(viewModel.productArray)
            return viewModel.productArray?.count ?? 0
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "MainCategoryCell", for: indexPath) as! MainCategoryCell
            cell.mainCategoryLabel.text = viewModel.mainCategoryArray[indexPath.row].name
            if viewModel.mainCategoryArray[indexPath.row].isSelected {
                cell.mainCategoryLabel.textColor = .white
                cell.mainCategoryBackgroundView.backgroundColor = UIColor(red: 0.36, green: 0.46, blue: 0.42, alpha: 1.0)
                viewModel.selectedIndexPath = indexPath
            }
            return cell
            
        case 1:
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "SubCategoryCell", for: indexPath) as! SubCategoryCell
            cell.subCategoryItemImage.image = UIImage(named: viewModel.subCategoryArray[indexPath.row].type ?? "")
            if viewModel.subCategoryArray[indexPath.row].isSelected ?? false {
                cell.subCategoryBackgroundView.layer.borderWidth = 1.0
                cell.subCategoryBackgroundView.layer.borderColor = UIColor(red: 0.36, green: 0.46, blue:0.42, alpha: 1.0).cgColor
                viewModel.selectedIndexPathForSubCategory = indexPath
            }
            return cell
            
        case 2:
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
            cell.animationDelegate = self
            if let product = viewModel.productArray?[indexPath.row]{
                if let imageUrl = URL(string: product.image?.src ?? "heart") {
                    cell.brandItemImage.kf.setImage(with: imageUrl)
                } else {
                    cell.brandItemImage.image = UIImage(named: "CouponBackground")
                }
                cell.itemLabel.text = product.title
                cell.itemPrice.text = product.variants?[0].price
            }
            
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let sectionHeaderArray: [String] = ["", "", "",""]
        if kind == BrandViewController.sectionHeaderElementKind {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as! SectionHeader
            headerView.label.text = sectionHeaderArray[indexPath.section]
            return headerView
        }
        return UICollectionReusableView()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        3
    }
}

// MARK: - Flow Layout
extension CategoryViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 5, height: 0)
    }
}

// MARK: - Delegate
extension CategoryViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        categoryCollectionView.deselectItem(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            if let cell = collectionView.cellForItem(at: indexPath) as? MainCategoryCell {
                if let previousSelectedIndexPath = viewModel.selectedIndexPath {
                    if let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? MainCategoryCell {
                        previousSelectedCell.isSelected = false
                        viewModel.mainCategoryArray[previousSelectedIndexPath.row].isSelected = false
                    }
                }
                cell.isSelected = true
                viewModel.mainCategoryArray[indexPath.row].isSelected = true
                viewModel.selectedIndexPath = indexPath
                viewModel.subCategoryArray[viewModel.selectedIndexPathForSubCategory?.row ?? 0].isSelected = false
                viewModel.filterMainCategrories()
            }
        case 1:
            if let cell = collectionView.cellForItem(at: indexPath) as? SubCategoryCell {
                if let previousSelectedIndexPath = viewModel.selectedIndexPathForSubCategory {
                    if let previousSelectedCell = collectionView.cellForItem(at: previousSelectedIndexPath) as? SubCategoryCell {
                        if viewModel.subCategoryArray[indexPath.row].isSelected {
                            previousSelectedCell.isSelected=false
                            viewModel.subCategoryArray[previousSelectedIndexPath.row].isSelected=false
                            viewModel.filterMainCategrories()
                            DispatchQueue.main.async {
                                collectionView.reloadData()
                            }
                            return
                        }
                        previousSelectedCell.isSelected = false
                        viewModel.subCategoryArray[previousSelectedIndexPath.row].isSelected = false
                    }
                }
                cell.isSelected = true
                viewModel.subCategoryArray[indexPath.row].isSelected = true
                viewModel.selectedIndexPathForSubCategory = indexPath
                DispatchQueue.main.async {
                    collectionView.reloadData()
                }
                if indexPath.row < viewModel.subCategoryArray.count {
                    viewModel.filterMainCategrories("&product_type=\(viewModel.subCategoryArray[indexPath.row].type)")
                }
            }
        default:
            return
        }
    }
}

// MARK: - Layout Functions
extension CategoryViewController {
    func mainCategories()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(50))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
        let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: BrandViewController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
    func subCategories()->NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(70), heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize , subitems: [item])
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        section.orthogonalScrollingBehavior = .continuous
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
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: headerSize, elementKind: BrandViewController.sectionHeaderElementKind, alignment: .top)
        section.boundarySupplementaryItems = [sectionHeader]
        return section
    }
    
}

// MARK: - Animation
extension CategoryViewController: FavoriteProtocol {
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
