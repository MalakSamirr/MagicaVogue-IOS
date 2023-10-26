//
//  UIView+showAlert.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/26/23.
//

import UIKit

extension UIViewController {
    func show(errorAlert error: NSError) {
        show(error.localizedDescription)
    }
    
    func show(messageAlert title: String, message: String? = "", actionTitle: String? = nil, action: ((UIAlertAction) -> Void)? = nil) {
        show(title, message: message, actionTitle: actionTitle, action: action)
    }
    
    fileprivate func show(_ title: String, message: String? = "", actionTitle: String? = nil, action: ((UIAlertAction) -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        if let _actionTitle = actionTitle {
            alert.addAction(UIAlertAction(title: _actionTitle, style: .default, handler: action))
        }
        let closeAction = NSLocalizedString("Close", comment: "")
        alert.addAction(UIAlertAction(title: closeAction, style: .cancel, handler: action))
        
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
