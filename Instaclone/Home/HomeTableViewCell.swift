//
//  HomeTableViewCell.swift
//  Instaclone
//
//  Created by Karsten Krause on 31.01.21.
//

import UIKit
import SDWebImage

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
    
    // MARK: - Property Observers
    var post: PostModel? {
        didSet {
            guard let imageURL = post?.imageURL else { return }
            guard let postDescription = post?.postDescription else { return }
            updateCellView(imageURL: imageURL, postDesrciption: postDescription)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProfileImage()
        setupButtonImages()
        
    }


    
    // MARK: - Methods
    func updateCellView(imageURL: String, postDesrciption: String) {
        guard let url = URL(string: imageURL) else { return }
        postImageView.sd_setImage(with: url) { (_, _, _, _) in
            
        }
        postTextLabel.text = postDesrciption
    }
    
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
