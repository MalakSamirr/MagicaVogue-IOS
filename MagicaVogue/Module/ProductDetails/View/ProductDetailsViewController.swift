//
//  ProductDetailsViewController.swift
//  MagicaVogue
//
//  Created by Malak Samir on 18/10/2023.
//

import UIKit

class ProductDetailsViewController: UIViewController , UICollectionViewDelegate,UICollectionViewDataSource , UICollectionViewDelegateFlowLayout ,UIScrollViewDelegate {
    

    @IBOutlet weak var sliderControlPage: UIPageControl!
    var currentCell = 0
    private var timer: Timer?
    
    let arrOfImgs = ["3","1","2"]
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var small: UIButton!
    
    @IBOutlet weak var medium: UIButton!
    
    
    @IBOutlet weak var large: UIButton!
    
    var myProduct : Products!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("-----------malak---------")
        
        print (myProduct.id)
        print("-----------malak---------")

        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: 1000)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "ProductImageCell", bundle: nil), forCellWithReuseIdentifier: "ProductImageCell")
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:collectionView.frame.width , height: 270)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal 
        collectionView.setCollectionViewLayout(layout, animated: false)
        
        automaticSlide()
        setupPageControl()
        collectionView?.isPagingEnabled = true
                collectionView?.decelerationRate = .fast

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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImageCell" , for: indexPath) as! ProductImageCell
        
        cell.img.image = UIImage(named: arrOfImgs[indexPath.row])
        return cell
    }
    
    
}
