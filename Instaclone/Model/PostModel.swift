//
//  PostModel.swift
//  Instaclone
//
//  Created by Karsten Krause on 01.02.21.
//

import Foundation
import FirebaseDatabase

class PostModel {
    var id: String?
    var userID: String?
    var imageURL: String?
    var postDescription: String?
    
    init(dictionary: [String : Any], key: String) {
        id = key
        userID = dictionary["userID"] as? String
        postDescription = dictionary["postDescription"] as? String
        imageURL = dictionary["imageURL"] as? String
    }
    
}
