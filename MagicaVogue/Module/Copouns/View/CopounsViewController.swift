//
//  CopounsViewController.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 19.10.2023.
//

import UIKit

class CopounsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
 
    
    @IBAction func checkoutPressed(_ sender: UIButton) {

//        let checkoutVC = CheckoutVC()
//        let nav = UINavigationController(rootViewController: checkoutVC)
//        nav.modalPresentationStyle = .pageSheet
//        
//        if let sheet = nav.sheetPresentationController {
//            sheet.detents = [.large()]
//            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
//            sheet.largestUndimmedDetentIdentifier = .medium
//        }
//        present(nav , animated: true , completion: nil)
        let checkoutVC = CheckoutVC()
          navigationController?.pushViewController(checkoutVC, animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
