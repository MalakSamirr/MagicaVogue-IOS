//
//  ProfileViewController.swift
//  MagicaVogue
//
//  Created by Malak Samir on 19/10/2023.
//

import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")


    }

   

}
extension ProfileViewController : UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        if(indexPath.row == 0){
            
            cell.img.image = UIImage(systemName: "person")
            cell.title.text = "Profile"
        }
        else if(indexPath.row == 1){
            
            cell.img.image = UIImage(systemName: "list.bullet.clipboard")
            cell.title.text = "My Orders"
        }
        else if(indexPath.row == 2){
            
            cell.img.image = UIImage(systemName: "creditcard")
            cell.title.text = "Payment Method"
        }
        else if(indexPath.row == 3){
            
            cell.img.image = UIImage(systemName: "gearshape")
            cell.title.text = "Settings"
        }
        else
        {
            cell.img.image = UIImage(systemName: "rectangle.portrait.and.arrow.right")
            cell.title.text = "Logout"
        }
               return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    
}
