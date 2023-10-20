//
//  HomeViewController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/18/23.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var branCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sliderControlPage: UIPageControl!
    @IBOutlet weak var couponCollectionView: UICollectionView!
    
    @IBOutlet weak var brandsCollectioView: UICollectionView!
    var currentCell = 0
    let arrOfImgs = ["CouponBackground","CouponBackground2", "CouponBackground3"]
    private var timer: Timer?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBar.frame = CGRect(x: searchBar.frame.origin.x, y: searchBar.frame.origin.y, width: searchBar.frame.size.width, height: 120)

        automaticSlide()
        setupPageControl()


        let logoImageView = UIImageView(image: UIImage(named: "Logo"))
        logoImageView.contentMode = .scaleAspectFit
        
        self.navigationItem.titleView = logoImageView
        
        
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
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(slide), userInfo: nil, repeats: true)
    }
    
    @objc func slide() {
        if currentCell < arrOfImgs.count - 1 {
            currentCell += 1
        } else {
            currentCell = 0
        }
        sliderControlPage.currentPage = currentCell
        let indexPath = IndexPath(row: sliderControlPage.currentPage, section: 0)
        if let frame = couponCollectionView?.layoutAttributesForItem(at: indexPath)?.frame {
            couponCollectionView?.scrollRectToVisible(frame, animated: true)
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


// MARK: - UICollectionView DataSource
extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case couponCollectionView:
            sliderControlPage.numberOfPages = arrOfImgs.count
            sliderControlPage.isHidden = !(arrOfImgs.count > 1)
            return arrOfImgs.count
        default:
            return 150
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
            cell.couponImage.image = UIImage(named: arrOfImgs[indexPath.row])
            return cell
        case brandsCollectioView:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BrandCell", for: indexPath) as! BrandCell
            // cell.brandImage.image = UIImage(named: arrOfImgs[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
}

// MARK: - UICollectionView Delegate
//extension HomeViewController: UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//    }
//}


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
                let numberOfRows = ceil(150/2)
                let cellHeight = (width - 15)/2-5
                let height = cellHeight*numberOfRows
            branCollectionViewHeight.constant = CGFloat(height)
            brandsCollectioView.layoutIfNeeded()
                
                return CGSize(width: (width - 15)/2-15, height: (width - 15)/2-15)
            
            default:
                return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }

    }
}

