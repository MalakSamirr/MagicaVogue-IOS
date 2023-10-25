//
//  UserLoginViewController.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 25.10.2023.
//
import UIKit

class UserLoginViewController: UIViewController, UICollectionViewDataSource , UITableViewDelegate ,UITableViewDataSource {
   
    @IBOutlet weak var loginOrdersTableView: UITableView!
    @IBOutlet weak var profileWishlistViewController: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()

        profileWishlistViewController.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        loginOrdersTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")

        profileWishlistViewController.dataSource = self
        loginOrdersTableView.dataSource = self
        loginOrdersTableView.delegate = self

        // Configure the layout for your profileWishlistViewController
        let layout = UICollectionViewCompositionalLayout { sectionIndex, environment in
            return self.items()
        }

        profileWishlistViewController.setCollectionViewLayout(layout, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = profileWishlistViewController.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
        cell.favoriteButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        return cell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = loginOrdersTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell else { return UITableViewCell() }
        cell.minus.isHidden = true
        cell.plus.isHidden = true
        cell.quantityLabel.isHidden = true
        cell.sizeLabel.text = "Size:XL || Qty:13"
        cell.productPriceLabel.isHidden = true
        cell.orderTotalLabel.isHidden = false
        cell.sizeLabel.textColor = .systemGray
        return cell
    }
    


    func items() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(0.65))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        group.interItemSpacing = .fixed(8)
        group.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 5, bottom: 0, trailing: 5)

        return section
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 100, height: 50) // Adjust the height as needed
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    @IBAction func moreOrdersButtonPressed(_ sender: Any) {
        let ordersVC = OrderViewController()
          navigationController?.pushViewController(ordersVC, animated: true)
    }
    
    @IBAction func moreWishlistButtonPressed(_ sender: Any) {
        let wishlistVC = WishListViewController()
          navigationController?.pushViewController(wishlistVC, animated: true)
    }
}
