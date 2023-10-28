//
//  SearchViewController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/26/23.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var searchCollectionView: UICollectionView!
    var viewModel: SearchViewModel = SearchViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        viewModel.onDataUpdate = { [weak self] in
                DispatchQueue.main.async {
                    self?.searchCollectionView.reloadData()
                }
            }
        viewModel.getCategories(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/products.json")

        let logoImageView = UIImageView(image: UIImage(named: "Logo"))
        logoImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logoImageView
        
        searchCollectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")

        searchCollectionView.delegate = self
        searchCollectionView.dataSource = self
        
        let layout = UICollectionViewCompositionalLayout { _,_ in
            return self.items()
        }
        searchCollectionView.setCollectionViewLayout(layout, animated: true)
        let indexPath = IndexPath(item: 0, section: 0)
    }
}


// MARK: - Data Source
extension SearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return viewModel.productArray?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = searchCollectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
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
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let product = viewModel.productArray?[indexPath.row]{
            let productDetailsVC = ProductDetailsViewController()
            productDetailsVC.myProduct = product
            
            self.navigationController?.pushViewController(productDetailsVC, animated: true)
        }
    }
}

// MARK: - Flow Layout
extension SearchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 5, height: 0)
    }
}

// MARK: - Delegate



// MARK: - Layout Functions
extension SearchViewController {

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
        return section
    }
    
}

// MARK: - Animation
extension SearchViewController: FavoriteProtocol {
    func deleteFromFavorite(_ itemId: Int) {
        print("cdfvgbhnjmkl")

    }
    
    func addToFavorite(_ id: Int ) {
        print("cdfvgbhnjmkl")
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
extension SearchViewController: UISearchBarDelegate {
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
            self.searchCollectionView.reloadData()
        }
    }
}
