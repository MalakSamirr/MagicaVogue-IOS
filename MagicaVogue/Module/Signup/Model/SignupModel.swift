//
//  SignupModel.swift
//  MagicaVogue
//
//  Created by Gsm on 01/11/2023.
//

import Foundation
import Firebase
import FirebaseAuth


struct AuthDataResultModel{
    let uid : String?
    let email : String?
    let photoUrl : String?
    let displayName : String?
    
    init(user : User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
        self.displayName = user.displayName
    }
}
