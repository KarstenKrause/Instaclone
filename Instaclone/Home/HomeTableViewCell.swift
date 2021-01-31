//
//  HomeTableViewCell.swift
//  Instaclone
//
//  Created by Karsten Krause on 31.01.21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var likeCounterLabel: UILabel!
    @IBOutlet weak var postTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProfileImage()
        setupButtonImages()
        
    }


    
    // MARK: - Methods
    func setupProfileImage() {
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
    }
    
    func setupButtonImages() {
        likeImageView.tintColor = UIColor(named: "oppositeBackground")
        commentImageView.tintColor = UIColor(named: "oppositeBackground")
        shareImageView.tintColor = UIColor(named: "oppositeBackground")
    }
    
    
    // MARK: - Actions

}
