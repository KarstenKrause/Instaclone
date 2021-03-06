//
//  HomeTableViewCell.swift
//  Instaclone
//
//  Created by Karsten Krause on 31.01.21.
//

import UIKit
import SDWebImage

/// protocol for triggering the segue after a tapping  the comment button
protocol HomeTableViewCellDelegate {
    func didTapCommentImageView(post: PostModel)
}

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
    
    // MARK: - Propterties
    
    // for saving a reference of the HomeViewController
    var delegate: HomeTableViewCellDelegate?
    
    // MARK: - Property Observers
    var post: PostModel? {
        didSet {
            guard let imageURL = post?.imageURL else { return }
            guard let postDescription = post?.postDescription else { return }
            updateCellView(imageURL: imageURL, postDesrciption: postDescription)
        }
    }
    
    var user: UserModel? {
        didSet {
            guard let username = user?.username else { return }
            guard let profileImageURL = user?.profileImageURL else { return }
            self.setupUserInfo(username: username, profileImageURL: profileImageURL)
        }
    }
    
    // MARK: - Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupProfileImage()
        setupButtonImages()
        addTapGestureToImageView()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "default_profile_m")
        postImageView.image = UIImage(named: "placeholder")
    }
    
    
    // MARK: - Methods
    func setupUserInfo(username: String, profileImageURL: String) {
        usernameLabel.text = username
        let url = URL(string: profileImageURL)
        profileImageView.sd_setImage(with: url) { (_, _, _, _) in }
    }
    
    func updateCellView(imageURL: String, postDesrciption: String) {
        guard let url = URL(string: imageURL) else { return }
        postImageView.sd_setImage(with: url) { (_, _, _, _) in }
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
    
    // Navigation to CommentViewController
    func addTapGestureToImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDidTapComment))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleDidTapComment() {
        guard let post = post else { return }
        delegate?.didTapCommentImageView(post: post)
    }
    

}
