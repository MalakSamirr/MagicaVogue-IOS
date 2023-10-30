//
//  OrderViewController.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/20/23.
//

import UIKit

class OrderViewController: UIViewController {
    

    @IBOutlet weak var orderTableView: UITableView!
    var cart: [DraftOrder] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let logoImageView = UIImageView(image: UIImage(named: "Logo"))
        logoImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logoImageView
        orderTableView.dataSource = self
        orderTableView.delegate = self
        orderTableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        // Do any additional setup after loading the view.
        print("cartttttttt\(cart)")

        self.navigationController?.isNavigationBarHidden = false
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


// MARK: - TableView
extension OrderViewController: UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = orderTableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as? CartCell else { return UITableViewCell() }
//        cell.minus.isHidden = true
//        cell.plus.isHidden = true
//        cell.quantityLabel.isHidden = true
//        cell.sizeLabel.text = "Size:XL || Qty:13"
//        cell.productPriceLabel.isHidden = true
//        cell.orderTotalLabel.isHidden = false
//        cell.sizeLabel.textColor = .systemGray
//        return cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
                       
            let draftOrder = cart[indexPath.row]
            if let lineItem = draftOrder.line_items.first, !lineItem.title.isEmpty {
                cell.productNameLabel.text = lineItem.title
                cell.quantityLabel.isHidden = true
                cell.sizeLabel.text = "Size:XL || Qty:\(lineItem.quantity)"
                cell.productPriceLabel.text = lineItem.price
                cell.minus.isHidden = true
                cell.plus.isHidden = true
                

            } else {
                cell.productNameLabel.text = "Product Name Not Available"
            }
        if let imageUrl = URL(string: draftOrder.applied_discount.description) {
            cell.productImageView.kf.setImage(with: imageUrl)
        } else {
            cell.productImageView.image = UIImage(named: "CouponBackground")
        }
            return cell
           
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Previous orders"
    }
}
