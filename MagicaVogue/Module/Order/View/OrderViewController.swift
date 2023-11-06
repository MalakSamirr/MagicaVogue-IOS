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
    var orderArray: [OrderModel] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        let logoImageView = UIImageView(image: UIImage(named: "Logo"))
        logoImageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = logoImageView
        orderTableView.dataSource = self
        orderTableView.delegate = self
        orderTableView.register(UINib(nibName: "OrderProfileTableVC", bundle: nil), forCellReuseIdentifier: "OrderProfileTableVC")
        // Do any additional setup after loading the view.
        print("cartttttttt\(cart)")

        self.navigationController?.isNavigationBarHidden = false
    }


}


// MARK: - TableView
extension OrderViewController: UITableViewDataSource, UITableViewDelegate, UICollectionViewDelegateFlowLayout {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return orderArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderProfileTableVC", for: indexPath) as! OrderProfileTableVC
        cell.createdAttLabel.text = formatDate(orderArray[indexPath.row].customer?.created_at ?? " ")
        cell.totalPriceLabel.text = orderArray[indexPath.row].total_price
           return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Previous orders"
    }
    
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        if let date = dateFormatter.date(from: dateString) {
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "MMMM d, yyyy, h:mm a"
            outputFormatter.locale = Locale(identifier: "en_US_POSIX")
            return outputFormatter.string(from: date)
        }
        
        return dateString // Return the original string if date parsing fails.
    }
    
    
}
