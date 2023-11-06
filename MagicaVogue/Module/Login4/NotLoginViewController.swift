//
//  NotLoginViewController.swift
//  MagicaVogue
//
//  Created by Gsm on 06/11/2023.
//

import UIKit

class NotLoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func SignupButton(_ sender: Any) {
        
        if let sceneDelegate = UIApplication.shared.connectedScenes
                    .first?.delegate as? SceneDelegate {
                    sceneDelegate.signupNavigation()
                }
    }
    
}
