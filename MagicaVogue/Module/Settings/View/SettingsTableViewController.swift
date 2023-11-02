//
//  SettingsTableViewController.swift
//  MagicaVogue
//
//  Created by Malak Samir on 19/10/2023.
//

import UIKit
import Firebase
import FirebaseAuth

class SettingsTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ProfileCell", bundle: nil), forCellReuseIdentifier: "ProfileCell")
        self.navigationController?.isNavigationBarHidden = false
        self.title = "Settings"
        self.navigationItem.leftBarButtonItem?.tintColor = .black
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
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
        else if(indexPath.row == 3){
            
            cell.img.image = UIImage(systemName: "arrow.uturn.left.circle")
            cell.title.text = "Logout"
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row==1){
            let currencyVC = CurrencyVC()
            navigationController?.pushViewController(currencyVC, animated: true)
        }
        else if(indexPath.row == 2){
            
            let alert1 = UIAlertController(
                title: "Delete Account", message: "Are you sure you want to delete your accout", preferredStyle: UIAlertController.Style.alert)
            
            let YesAction = UIAlertAction(title: "yes,delete" , style : .default) { (action) in
                let user = Auth.auth().currentUser
                
                user?.delete { error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else {
                        if let sceneDelegate = UIApplication.shared.connectedScenes
                                    .first?.delegate as? SceneDelegate {
                                    sceneDelegate.resetAppNavigation()
                                }
                        
                    }
                }
            }
            let NoAction = UIAlertAction(title: "No" , style : .default) { (action) in
                
            }
            
            alert1.addAction(YesAction)
            alert1.addAction(NoAction)
            
            
            present(alert1, animated: true , completion: nil)
            
            
            return
            
            
            
            
        }
        if(indexPath.row==3){
            
            let alert1 = UIAlertController(
                title: "Logout", message: "Are you sure you want to logout!", preferredStyle: UIAlertController.Style.alert)
            
            let YesAction = UIAlertAction(title: "yes,Logout" , style : .default) { (action) in
                let firebaseAuth = Auth.auth()
                do {
                    try firebaseAuth.signOut()
                    if let sceneDelegate = UIApplication.shared.connectedScenes
                                .first?.delegate as? SceneDelegate {
                                sceneDelegate.resetAppNavigation()
                            }
                } catch let signOutError as NSError {
                    print("Error signing out: %@", signOutError)
                }
                
            }
            
            
            let NoAction = UIAlertAction(title: "No" , style : .default) { (action) in
                
            }
            
            alert1.addAction(YesAction)
            alert1.addAction(NoAction)
            
            
            present(alert1, animated: true , completion: nil)
            
            
            return
        }
    }
}
