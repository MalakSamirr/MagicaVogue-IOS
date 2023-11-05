//
//  TabBarController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/20/23.
//

import UIKit

class TabBarController: UITabBarController, UITabBarControllerDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

        let homeController = HomeViewController()
        let favoriteController = WishListViewController()
        let categoryController = CategoryViewController()
        let profileController = UserLoginViewController()
        let cartController = CartViewController()
        cartController.title = "Cart"
        favoriteController.title = "Wishlist"
        homeController.title = "Home"
        categoryController.title = "Discover"
        profileController.title = "Me"
        
        let homeNavController = UINavigationController(rootViewController: homeController)
        let favoriteNavController = UINavigationController(rootViewController: favoriteController)
        let categoryNavController = UINavigationController(rootViewController: categoryController)
        let profileNavController = UINavigationController(rootViewController: profileController)
        let cartNavController = UINavigationController(rootViewController: cartController)
        
        // Set the view controllers for the tab bar controller
        self.setViewControllers([homeNavController, categoryNavController, favoriteNavController, cartNavController, profileNavController], animated: true)
        
        guard let items = self.tabBar.items else {return}
        let images = ["house", "magnifyingglass","heart","cart","person.crop.circle"]
        
        for i in 0...4 {
            items[i].image = UIImage(systemName: images[i])
        }
        self.tabBar.tintColor = UIColor(red: 0.26, green: 0.36, blue:0.32, alpha: 1.0)
        self.tabBar.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.setNeedsLayout()
        navigationController?.isNavigationBarHidden = true
    }
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
          // Check if the selected tab is the "Home" tab
          if let homeNavController = viewController as? UINavigationController,
             let homeViewController = homeNavController.viewControllers.first,
             homeViewController is HomeViewController {
              // Check if the top view controller in the "Home" navigation stack is "BrandViewController"
              if homeNavController.viewControllers.last is BrandViewController {
                  // Pop "BrandViewController" to return to the "Home" view controller
                  homeNavController.popToViewController(homeViewController, animated: false)
              }
              if homeNavController.viewControllers.last is ProductDetailsViewController {
                  // Pop "BrandViewController" to return to the "Home" view controller
                  homeNavController.popToViewController(homeViewController, animated: false)
              }
          }
      }
}

