//
//  PaymentViewController.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 20.10.2023.
//

import UIKit

class PaymentViewController: UIViewController , UITableViewDelegate , UITableViewDataSource {
    @IBOutlet var payementParentView: UIView!
    
    @IBOutlet weak var paymentBackgroundView: UIView!
    
    @IBOutlet weak var paymentTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        payementParentView.layer.cornerRadius = 24
        payementParentView.clipsToBounds = true
        paymentBackgroundView.layer.cornerRadius = 24
        paymentBackgroundView.clipsToBounds = true
       
        payementParentView.dropShadow()
        paymentTable.delegate = self
        paymentTable.dataSource = self
        paymentTable.register(UINib(nibName: "PaymentCell", bundle: nil), forCellReuseIdentifier: "PaymentCell")
        paymentTable.separatorStyle = .none


        // Do any additional setup after loading the view.
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PaymentCell", for: indexPath) as! PaymentCell
        
        return cell

    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        
        let headerLabel = UILabel()
        headerLabel.font = UIFont.boldSystemFont(ofSize: 17)
        headerLabel.text = tableView.dataSource?.tableView?(tableView, titleForHeaderInSection: section)
        
        headerView.addSubview(headerLabel)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let inset: CGFloat = 20.0
        let leftConstraint = headerLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: inset)
        leftConstraint.isActive = true
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {

        return "Payment Options"
       
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
