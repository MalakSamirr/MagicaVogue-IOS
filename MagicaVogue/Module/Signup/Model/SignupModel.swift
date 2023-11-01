//
//  SignupModel.swift
//  MagicaVogue
//
//  Created by Gsm on 01/11/2023.
//

import Foundation
import Firebase
import FirebaseAuth

struct GooogleSignUpModel{
    let idToken : String
    let accessToken : String
}
struct AuthDataResultModel{
    let uid : String?
    let email : String?
    let photoUrl : String?
    
    init(user : User) {
        self.uid = user.uid
        self.email = user.email
        self.photoUrl = user.photoURL?.absoluteString
    }
}
