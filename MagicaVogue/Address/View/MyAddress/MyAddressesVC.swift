//
//  MyAddressesVC.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 19.10.2023.
//

import UIKit

class MyAddressesVC: ViewController  , UITableViewDataSource , UITableViewDelegate {
   
    

    @IBOutlet weak var addressTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Shipping Address"
        self.navigationController?.navigationBar.backgroundColor = .white
        addressTable.delegate = self
        addressTable.dataSource = self
        addressTable.register(UINib(nibName: "NewAddressCell", bundle: nil), forCellReuseIdentifier: "NewAddressCell")

        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewAddressCell", for: indexPath) as! NewAddressCell
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        
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
