//
//  PostModel.swift
//  Instaclone
//
//  Created by Karsten Krause on 01.02.21.
//

import Foundation
import FirebaseDatabase

class PostModel {
    var imageURL: String?
    var postDescription: String?
    
    init(dbDictionary: [String : Any]) {
        postDescription = dbDictionary["postDescription"] as? String
        imageURL = dbDictionary["imageURL"] as? String
    }
    
}
