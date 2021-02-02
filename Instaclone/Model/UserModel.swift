//
//  UserModel.swift
//  Instaclone
//
//  Created by Karsten Krause on 02.02.21.
//

import Foundation


class UserModel {
    var userID: String?
    var username: String?
    var name: String?
    var email: String?
    var profileImageURL: String?
    var userDescription: String?
    var hasSubscribed: Bool?
    
    init(userDictionary: [String : Any]) {
        userID = userDictionary["userID"] as? String
        username = userDictionary["username"] as? String
        name = userDictionary["name"] as? String
        email = userDictionary["email"] as? String
        profileImageURL = userDictionary["profilImage_URL"] as? String
        userDescription = userDictionary["userDescription"] as? String
    }
}
