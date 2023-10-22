//
//  SettingsTableViewController.swift
//  MagicaVogue
//
//  Created by Malak Samir on 19/10/2023.
//

import UIKit

class SettingsTableViewController: UITableViewController {
        
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell", for: indexPath) as! ProfileCell
        if(indexPath.row == 0){
            
            cell.img.image = UIImage(systemName: "key")
            cell.title.text = "Password Manager"
        }
        else if(indexPath.row == 1){
            
            cell.img.image = UIImage(systemName: "coloncurrencysign")
            cell.title.text = "Currency"
        }
        else if(indexPath.row == 2){
            
            cell.img.image = UIImage(systemName: "delete.right")
            cell.title.text = "Delete Account"
        }
        
               return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    
}
