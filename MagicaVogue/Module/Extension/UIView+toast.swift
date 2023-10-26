//
//  UIView+toast.swift
//  MagicaVogue
//
//  Created by Hoda Elnaghy on 10/26/23.
//

import UIKit

class ToastView: UIView {
    @IBOutlet var messageLabel: UILabel!
    
    static func show(message: String, in view: UIView, for duration: TimeInterval = 1.0) {
        let toastView = Bundle.main.loadNibNamed("ToastView", owner: nil, options: nil)?.first as! ToastView
        toastView.messageLabel.text = message
        view.addSubview(toastView)
        
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toastView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            toastView.removeFromSuperview()
        }
    }
}
