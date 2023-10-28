//
//  ProductDetailsViewController.swift
//  MagicaVogue
//
//  Created by Malak Samir on 18/10/2023.
//

import UIKit
import Kingfisher

class ProductDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {

    @IBOutlet weak var optionsCollectionView: UICollectionView!
    @IBOutlet weak var sliderControlPage: UIPageControl!
    var currentCell = 0
    private var timer: Timer?
    var selectedIndexPathForSize: IndexPath?
    var selectedIndexPathForColor: IndexPath?
    static let sectionHeaderElementKind = "section-header-element-kind"

    struct ProductOption {
        let name: String
        var isSelected: Bool
    }
    
    var productSizes: [ProductOption] = []
    var productColors: [ProductOption] = []
    
    var arrOfProductImgs: [String] = []
    var arrOfSize: [String] = []
    var arrOfColor: [String] = []
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDetails: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    var myProduct: Products!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for image in myProduct.images! {
            arrOfProductImgs.append(image.src ?? "")
        }
        
        self.optionsCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: ProductDetailsViewController.sectionHeaderElementKind, withReuseIdentifier: SectionHeader.reuseIdentifier)

        
        if let values = myProduct.options?[0].values, !values.isEmpty {
            var isFirstSize = true

            for size in values {
                arrOfSize.append(size)
                var productOption: ProductOption
                if isFirstSize {
                    productOption = ProductOption(name: size, isSelected: true)
                    isFirstSize = false
                }
                else {
                    productOption = ProductOption(name: size, isSelected: false)
                }
                    
                productSizes.append(productOption)
            }
        }
        print(arrOfSize)
        print("--------------------")
        if let values = myProduct.options?[1].values, !values.isEmpty {
            var isFirstColor = true
            for color in values {
                arrOfColor.append(color)
                var productOption: ProductOption
                if isFirstColor {
                    productOption = ProductOption(name: color, isSelected: true)
                    isFirstColor = false
                } else {
                    productOption = ProductOption(name: color, isSelected: false)

                }
                productColors.append(productOption)
            }
        }
        print(arrOfColor)
        productPrice.text = "EG\(myProduct.variants?[0].price ?? "0")"
        productName.text = myProduct.title
        productDetails.text = myProduct.body_html
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: 1000)
        
        optionsCollectionView.dataSource = self
        optionsCollectionView.delegate = self
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "ProductImageCell")
        
        optionsCollectionView.register(UINib(nibName: "MainCategoryCell", bundle: nil), forCellWithReuseIdentifier: "MainCategoryCell")
        
        // Add a section header to optionsCollectionView
    
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: collectionView.frame.width, height: 270)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        automaticSlide()
        setupPageControl()
        collectionView?.isPagingEnabled = true
        collectionView?.decelerationRate = .fast
        
        self.optionsCollectionView.register( SectionHeader.self, forSupplementaryViewOfKind: BrandViewController.sectionHeaderElementKind, withReuseIdentifier: SectionHeader.reuseIdentifier)
        
        let layout1 = UICollectionViewCompositionalLayout { sectionIndex, enviroment in
            switch sectionIndex {
            case 0:
                return self.sizeLayout()
            default:
                return self.colorsLayout()
            }
        }
        optionsCollectionView.setCollectionViewLayout(layout1, animated: true)
    
    }

    private func setupPageControl() {
        sliderControlPage?.hidesForSinglePage = true
        sliderControlPage?.addTarget(self, action: #selector(pageControlHandle), for: .valueChanged)
    }

    @objc private func pageControlHandle(sender: UIPageControl) {
        let indexPath = IndexPath(row: sender.currentPage, section: 0)
        if let frame = collectionView?.layoutAttributesForItem(at: indexPath)?.frame {
            collectionView?.scrollRectToVisible(frame, animated: true)
        }
    }

    private func automaticSlide() {
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(slide), userInfo: nil, repeats: true)
    }

    @objc func slide() {
        if currentCell < arrOfProductImgs.count - 1 {
            currentCell += 1
        } else {
            currentCell = 0
        }
        sliderControlPage.currentPage = currentCell
        let indexPath = IndexPath(row: sliderControlPage.currentPage, section: 0)
        if let frame = collectionView?.layoutAttributesForItem(at: indexPath)?.frame {
            collectionView?.scrollRectToVisible(frame, animated: true)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.width
        sliderControlPage?.currentPage = Int(ceil(pageNumber))
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        sliderControlPage?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        switch collectionView {
        case self.collectionView:
            return 1
        case optionsCollectionView:
            return 2
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case self.collectionView:
            return arrOfProductImgs.count
        case optionsCollectionView:
            switch section {
            case 0:
                return arrOfSize.count
            case 1:
                return arrOfColor.count
            default:
                return 0
            }

        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case self.collectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell", for: indexPath) as! ProductImageCell
            let img = arrOfProductImgs[indexPath.row]
            if let imageUrl = URL(string: img) {
                cell.img.kf.setImage(with: imageUrl)
            }
            return cell
        case optionsCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCategoryCell", for: indexPath) as! MainCategoryCell
            switch indexPath.section {
            case 0:
                cell.mainCategoryLabel.text = arrOfSize[indexPath.row]
                if (productSizes[indexPath.row].isSelected) {
                    cell.mainCategoryLabel.textColor = .white
                    cell.mainCategoryBackgroundView.backgroundColor = UIColor(red: 0.36, green: 0.46, blue: 0.42, alpha: 1.0)
                    
                }
            case 1:
                if (productColors[indexPath.row].isSelected) {
                    cell.mainCategoryLabel.textColor = .white
                    cell.mainCategoryBackgroundView.backgroundColor = UIColor(red: 0.36, green: 0.46, blue: 0.42, alpha: 1.0)
                    
                }
                
                cell.mainCategoryLabel.text = arrOfColor[indexPath.row]
            default:
                cell.mainCategoryLabel.text = "empty"
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == optionsCollectionView {
            if (indexPath.section == 0){
                return CGSize(width: 50, height: 50)
            }else {
                return CGSize(width: 100, height: 50)

            }
        }
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if (collectionView == optionsCollectionView){
            
            return CGSize(width: collectionView.frame.width, height: 50)
        }
        return CGSize(width: 0, height: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == optionsCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainCategoryCell", for: indexPath) as! MainCategoryCell
            
            if indexPath.section == 0 {
                for index in 0..<productSizes.count {
                    productSizes[index].isSelected = false
                }
                
                productSizes[indexPath.row].isSelected = true
            }
            else {
                for index in 0..<productColors.count {
                    productColors[index].isSelected = false
                }
                
                productColors[indexPath.row].isSelected = true
            }
            collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if collectionView == optionsCollectionView {
            let sectionHeaderArray: [String] = ["Size", "Color"]
            if kind == ProductDetailsViewController.sectionHeaderElementKind {
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeader.reuseIdentifier, for: indexPath) as! SectionHeader
                headerView.label.text = sectionHeaderArray[indexPath.section]
                return headerView
            }
        }
        return UICollectionReusableView()
    }
    
    
    func colorsLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(100), heightDimension: .absolute(50))
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
    
    func sizeLayout()-> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(50), heightDimension: .absolute(50))
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
    
    
    
}
