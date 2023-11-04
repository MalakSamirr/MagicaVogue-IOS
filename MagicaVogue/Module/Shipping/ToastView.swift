//
//  ToastView.swift
//  MagicaVogue
//
//  Created by Heba Elcc on 2.11.2023.
//

import UIKit

class ToastView1: UIView {
    init(message: String) {
        super.init(frame: CGRect.zero)

        self.backgroundColor = UIColor.green.withAlphaComponent(0.3)
        self.layer.cornerRadius = 10

        let label = UILabel()
        label.text = message
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 0

        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class ToastView2: UIView {
    init(message: String) {
        super.init(frame: CGRect.zero)

        self.backgroundColor = UIColor.red.withAlphaComponent(0.7)
        self.layer.cornerRadius = 10

        let label = UILabel()
        label.text = message
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0

        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            label.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8)
        ])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
