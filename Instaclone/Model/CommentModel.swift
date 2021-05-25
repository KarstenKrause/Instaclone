//
//  CommentModel.swift
//  Instaclone
//
//  Created by Karsten Krause on 25.05.21.
//

import Foundation

class CommentModel {
    var userID: String?
    var commentText: String?
    
    init(dictionary: [String : Any]) {
        commentText = dictionary["commentText"] as? String
        userID = dictionary["userID"] as? String
    }
}
