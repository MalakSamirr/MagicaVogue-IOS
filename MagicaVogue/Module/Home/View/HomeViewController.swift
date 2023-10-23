//
//  HomeViewController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/18/23.
//

import UIKit
import Alamofire
import Kingfisher
class HomeViewController: UIViewController {
    var brandArray: [SmartCollection]?
    // MARK: - Outlets
    
    @IBOutlet weak var branCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var sliderControlPage: UIPageControl!
    @IBOutlet weak var couponCollectionView: UICollectionView!
    
    @IBOutlet weak var brandsCollectioView: UICollectionView!
    var currentCell = 0
    let arrOfImgs = ["couponBackground5","couponBackground5", "couponBackground5"]
    private var timer: Timer?
    override func viewDidLoad() {
        
        super.viewDidLoad()
        searchBar.frame = CGRect(x: searchBar.frame.origin.x, y: searchBar.frame.origin.y, width: searchBar.frame.size.width, height: 120)
        fetchBrands()
        automaticSlide()
        setupPageControl()
        
        self.title = "Home"

        let logoImageView = UIImageView(image: UIImage(named: "logo4"))
        logoImageView.contentMode = .scaleAspectFit

        // Create a custom UIBarButtonItem with the logoImageView
        let logoBarButton = UIBarButtonItem(customView: logoImageView)

        // Assign the custom UIBarButtonItem to the right bar button item
        self.navigationItem.rightBarButtonItem = logoBarButton

        
        
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
    func getBrands() {
        
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
            print(brandArray?.count)
            return brandArray?.count ?? 5
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
            
            
            if let brand = brandArray?[indexPath.row], let imageUrl = URL(string: brand.image.src ?? "heart") {
                
                    cell.brandImage.kf.setImage(with: imageUrl)
                } else {
                    // Handle the case when the image URL is invalid or missing
                    cell.brandImage.image = UIImage(named: "CouponBackground")
                }
                        
                        
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
            let count = Int(brandArray?.count ?? 0)
            let numberOfRows = ceil(Double(count/2))
            let cellHeight = (width - 15)/2-5
            let height = cellHeight*numberOfRows
            branCollectionViewHeight.constant = CGFloat(height)
            brandsCollectioView.layoutIfNeeded()
            
            return CGSize(width: (width - 15)/2-15, height: (width - 15)/2-25)
            
        default:
            return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let brandViewController = BrandViewController()
            self.navigationController?.pushViewController(brandViewController, animated: true)
        }
//    func fetchBrands() {
//        let url = "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/smart_collections.json"
//
//        AF.request(url, method: .get)
//            .validate()
//            .responseJSON { response in
//                switch response.result {
//                case .success:
//                    if let data = response.data {
//                        // Convert data to a string for printing
//                        if let jsonString = String(data: data, encoding: .utf8) {
//
//                        }
//                        do {
//                            let decoder = JSONDecoder()
//                            let apiResponse = try decoder.decode(HomeModel.self, from: data)
//
//                            // print(apiResponse)
//                            self.brandArray = apiResponse.smart_collections
//                            print(self.brandArray)
//
//                            DispatchQueue.main.async {
//                                self.brandsCollectioView.reloadData()
//                            }
//                            } catch {
//                                print("Error decoding JSON: \(error)")
//                                                // Handle the decoding error as needed.
//                                            }
//
//                    }
//                case .failure(let error):
//                    print("Request failed with error: \(error)")
//                    // Handle the request failure as needed.
//                }
//            }
//    }
    func fetchBrands() {
        let url = "https://9ec35bc5ffc50f6db2fd830b0fd373ac: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@ios-q1-new-capital-2023.myshopify.com/admin/api/2023-01/smart_collections.json"

        APIManager.shared.request(.get, url) { [weak self] (result: Result<HomeModel, Error>) in
            guard let self = self else { return }
            
            switch result {
            case .success(let apiResponse):
                self.brandArray = apiResponse.smart_collections
                DispatchQueue.main.async {
                    self.brandsCollectioView.reloadData()
                    print(self.brandArray)
                }
            case .failure(let error):
                print("Error: \(error)")
                // Handle the error as needed.
            }
        }
    }

}

