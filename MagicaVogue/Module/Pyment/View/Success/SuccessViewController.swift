//
//  SuccessViewController.swift
//  MagicaVogue
//
//  Created by Shimaa Elcc on 20.10.2023.
//

import UIKit

class SuccessViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }

    @IBAction func ContinueButtonPressed(_ sender: Any) {
        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                         sceneDelegate.rootNavigation()
                     }
    }
    
    


}
