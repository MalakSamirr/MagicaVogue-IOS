//
//  ProfileOrdersCollectionViewCell.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 25.10.2023.
//

import UIKit

class ProfileOrdersCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var tableView: UITableView!
    var orders: [String]?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tableView.register(UINib(nibName: "CartCell", bundle: nil), forCellReuseIdentifier: "CartCell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupUI(order: [String]) {
        self.orders = order
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
}

extension ProfileOrdersCollectionViewCell: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         let cell = tableView.dequeueReusableCell(withIdentifier: "CartCell", for: indexPath) as! CartCell
        cell.minus.isHidden = true
        cell.plus.isHidden = true
        cell.quantityLabel.isHidden = true
        cell.sizeLabel.text = "Size:XL || Qty:13"
        cell.productPriceLabel.isHidden = true
        cell.orderTotalLabel.isHidden = false
        cell.sizeLabel.textColor = .systemGray
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
}
