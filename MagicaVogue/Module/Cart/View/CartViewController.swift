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
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
          if editingStyle == .delete {
              // Display an alert for confirmation
              let alertController = UIAlertController(
                  title: "Delete Item",
                  message: "Are you sure you want to remove this item from your shopping bag?",
                  preferredStyle: .actionSheet
              )

              let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { [weak self] _ in
//
                  
              }

              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

              alertController.addAction(deleteAction)
              alertController.addAction(cancelAction)

              if let popoverController = alertController.popoverPresentationController {
                  if let cell = tableView.cellForRow(at: indexPath) {
                      popoverController.sourceView = cell
                      popoverController.sourceRect = cell.bounds
                  }
              }

              present(alertController, animated: true, completion: nil)
          }
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
