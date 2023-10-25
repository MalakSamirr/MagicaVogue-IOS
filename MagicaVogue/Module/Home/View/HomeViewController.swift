//
//  HomeViewController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/18/23.
//

import UIKit
import Alamofire
import Kingfisher
class HomeViewController: UIViewController, UISearchBarDelegate {
    // MARK: - Outlets
    
    @IBOutlet weak var branCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sliderControlPage: UIPageControl!
    @IBOutlet weak var couponCollectionView: UICollectionView!
    @IBOutlet weak var brandsCollectioView: UICollectionView!
    var viewModel: HomeViewModel = HomeViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.frame = CGRect(x: searchBar.frame.origin.x, y: searchBar.frame.origin.y, width: searchBar.frame.size.width, height: 120)
        viewModel.getBrands(url: "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/smart_collections.json")
        viewModel.onDataUpdate = { [weak self] in
            DispatchQueue.main.async {
                self?.brandsCollectioView.reloadData()
            }
        }
        automaticSlide()
        setupPageControl()
        searchBar.delegate = self
        self.title = "Home"
        couponCollectionView?.isPagingEnabled = true
        couponCollectionView?.decelerationRate = .fast
        brandsCollectioView.delegate = self
        brandsCollectioView.dataSource = self
        brandsCollectioView.register(UINib(nibName: "BrandCell", bundle: nil), forCellWithReuseIdentifier: "BrandCell")
        couponCollectionView.delegate = self
        couponCollectionView.dataSource = self
        couponCollectionView.register(UINib(nibName: "CouponCell", bundle: nil), forCellWithReuseIdentifier: "CouponCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        brandsCollectioView.reloadData()
        viewDidLayoutSubviews()
    }
    
    private func setupPageControl() {
        sliderControlPage?.hidesForSinglePage = true
        sliderControlPage?.addTarget(self, action: #selector(pageControlHandle), for: .valueChanged)
    }
    
    @objc private func pageControlHandle(sender: UIPageControl) {
        let indexPath = IndexPath(row: sender.currentPage, section: 0)
        if let frame = couponCollectionView?.layoutAttributesForItem(at: indexPath)?.frame {
            couponCollectionView?.scrollRectToVisible(frame, animated: true)
        }
    }
    
    private func automaticSlide () {
        viewModel.timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(slide), userInfo: nil, repeats: true)
    }
    
    @objc func slide() {
        if viewModel.currentCell < viewModel.arrOfImgs.count - 1 {
            viewModel.currentCell += 1
        } else {
            viewModel.currentCell = 0
        }
        sliderControlPage.currentPage = viewModel.currentCell
        let indexPath = IndexPath(row: sliderControlPage.currentPage, section: 0)
        if let frame = couponCollectionView?.layoutAttributesForItem(at: indexPath)?.frame {
            couponCollectionView?.scrollRectToVisible(frame, animated: true)
        }
    }
}

// MARK: - UICollectionView DataSource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case couponCollectionView:
            sliderControlPage.numberOfPages = viewModel.arrOfImgs.count
            sliderControlPage.isHidden = !(viewModel.arrOfImgs.count > 1)
            return viewModel.arrOfImgs.count
        default:
            return viewModel.brandArray?.count ?? 0
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = scrollView.contentOffset.x / scrollView.frame.width
        sliderControlPage?.currentPage = Int(ceil(pageNumber))
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        sliderControlPage?.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch collectionView {
        case couponCollectionView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CouponCell", for: indexPath) as! CouponCell
            cell.couponImage.image = UIImage(named: viewModel.arrOfImgs[indexPath.row])
            return cell
        case brandsCollectioView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as! BrandCell
            if let brand = viewModel.brandArray?[indexPath.row], let imageUrl = URL(string: brand.image.src ?? "heart") {
                cell.brandImage.kf.setImage(with: imageUrl)
            } else {
                cell.brandImage.image = UIImage(named: "CouponBackground")
            }
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionView DelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 8, bottom: 5, right: 8)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        switch collectionView {
        case couponCollectionView:
            return CGSize(width: collectionView.frame.width-5, height: collectionView.frame.height)
            
        case brandsCollectioView:
            let count = Int(viewModel.brandArray?.count ?? 0)
            let numberOfRows = ceil((Double(count)/2.0))
            let cellHeight = (width - 15)/2-5
            let height = cellHeight*numberOfRows
            branCollectionViewHeight.constant = CGFloat(height)
            brandsCollectioView.layoutIfNeeded()
            return CGSize(width: (width - 15)/2-15, height: (width-30)/2-25)
        default:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            
            let brandViewController = BrandViewController()
            brandViewController.viewModel.brand = viewModel.brandArray?[indexPath.row]
            self.navigationController?.pushViewController(brandViewController, animated: true)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.brandArray = viewModel.dataArray
        } else {
            viewModel.brandArray = viewModel.dataArray?.filter { brand in
                if let title = brand.title, title.lowercased().contains(searchText.lowercased()) {
                    return true
                }
                return false
            }
        }
        DispatchQueue.main.async {
            self.brandsCollectioView.reloadData()
        }
    }
}

