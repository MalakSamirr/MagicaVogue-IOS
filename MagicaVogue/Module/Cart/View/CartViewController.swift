//
//  CartViewController.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 18.10.2023.
//

import UIKit

class CartViewController: UIViewController , UITableViewDataSource , UITableViewDelegate {
    
    
    @IBOutlet weak var CartTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Shopping Bag"
        self.navigationController?.navigationBar.backgroundColor = .white
        CartTableView.delegate = self
        CartTableView.dataSource = self
        CartTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        

    }
  
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }

  
    @IBAction func Checkout(_ sender: UIButton) {
//        let copounsViewController = CopounsViewController()
//        let nav = UINavigationController(rootViewController: copounsViewController)
//        nav.modalPresentationStyle = .pageSheet
//
//        if let sheet = nav.sheetPresentationController {
//            sheet.detents = [.medium()]
//            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//            sheet.largestUndimmedDetentIdentifier = .medium
//        }
//        present(nav , animated: true , completion: nil)
        let checkoutVC = CheckoutVC()
          navigationController?.pushViewController(checkoutVC, animated: true)
        
    }
    


}
