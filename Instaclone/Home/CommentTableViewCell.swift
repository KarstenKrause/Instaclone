//
//  CommentTableViewCell.swift
//  Instaclone
//
//  Created by Karsten Krause on 16.05.21.
//

import UIKit
import SDWebImage

class CommentTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var commentTextLabel: UILabel!
    
    // MARK: - Properties
    var comment: CommentModel?
    
    // MARK: - Property Observers
    var user: UserModel? {
        didSet {
            guard let _commentText = comment?.commentText else { return }
            guard let _username = user?.username else { return }
            guard let _profileImageURL = user?.profileImageURL else { return }
            setupCellView(commentText: _commentText, userName: _username, profileImageURL: _profileImageURL)
        }
    }
    
    func setupCellView(commentText: String, userName: String, profileImageURL: String) {
        let attributedText = NSMutableAttributedString(string: userName, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSMutableAttributedString(string: "\n" + commentText, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)]))
        commentTextLabel.attributedText = attributedText
        
        guard let imageURL = URL(string: profileImageURL) else { return }
        profileImageView.sd_setImage(with: imageURL) { (_, _, _, _) in }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        commentTextLabel.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
