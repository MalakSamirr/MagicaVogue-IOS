//
//  UserProfileViewController.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 25.10.2023.
//

import UIKit

class UserProfileViewController: UIViewController {
    var OrderDelegate: MoreProtocol?
    var wishlistDelegate: MoreProtocol?

    @IBOutlet weak var collectionView: UICollectionView!
    var viewModel: UserProfileViewModel!
    
    convenience init(viewModel: UserProfileViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.setSetions()
        collectionView.register(UINib(nibName: "ItemCell", bundle: nil), forCellWithReuseIdentifier: "ItemCell")
        
        collectionView.register(UINib(nibName: "LabelAndButtonCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "LabelAndButtonCollectionViewCell")

        collectionView.register(UINib(nibName: "ProfileOrdersCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProfileOrdersCollectionViewCell")

    }

}

extension UserProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let section = viewModel.profileSection[section]
        switch section {
        case .wishlist:
            return 4
        default:
            return 1

        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let section = viewModel.profileSection[indexPath.section]
        switch section {
        
        case .welcomingMessage:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelAndButtonCollectionViewCell", for: indexPath) as! LabelAndButtonCollectionViewCell
            cell.setupUI(labelTitle: "Welcome, Heba🫶", buttonTitle: "")
            return cell
        case .orders:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileOrdersCollectionViewCell", for: indexPath) as! ProfileOrdersCollectionViewCell
            cell.setupUI(order: [])
            return cell
            
        case .wishlist:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemCell", for: indexPath) as! ItemCell
            return cell
        case .header(title: let title, actionTitle: let actionTitle):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LabelAndButtonCollectionViewCell", for: indexPath) as! LabelAndButtonCollectionViewCell
            cell.setupUI(labelTitle: title, buttonTitle: actionTitle)
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let section = viewModel.profileSection[indexPath.section]
        switch section {
        case .orders:
            return CGSize(width: UIScreen.main.bounds.width, height: 300)
        case .wishlist:
            return CGSize(width: (collectionView.bounds.width / 2) - 20 , height: 250)
        default:
            return CGSize(width: UIScreen.main.bounds.width, height: 50)
        }
    }
}
