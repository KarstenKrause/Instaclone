//
//  CommentViewController.swift
//  Instaclone
//
//  Created by Karsten Krause on 16.05.21.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import ProgressHUD

class CommentViewController: UIViewController {
    
    // MARK: Properties
    var post: PostModel?
    var comments = [CommentModel]()
    var users = [UserModel]()
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.keyboardDismissMode = .interactive
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        sendButton.setTitleColor(.lightGray, for: .normal)
        sendButton.isEnabled = false
        addTargetToTextField()
        loadComments()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        tabBarController?.tabBar.isTranslucent = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.tabBar.isTranslucent = false
    }

    
    // MARK: - Send commend
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        createComment()
        view.endEditing(true)
        clearTextField()
    }
    
    func createComment() {
        let databaseRef = Database.database().reference()
        let commentsRef = databaseRef.child("comments")
        
        guard let commentId = commentsRef.childByAutoId().key else {return}
        guard let userID = Auth.auth().currentUser?.uid else {return}
        
        let newCommentRef = commentsRef.child(commentId)
        let dic = ["userID" : userID ,"commentText" : commentTextField.text!] as [String : Any]
        newCommentRef.setValue(dic) { (error, ref) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
            }
            
            guard let postID = self.post?.id else { return }
            let postCommentRef = Database.database().reference().child("assignedPostComments").child(postID).child(commentId)
            postCommentRef.setValue(true) { error, ref in
                if error != nil {
                    ProgressHUD.showError(error?.localizedDescription)
                    return
                }
                self.view.endEditing(true)
                self.clearTextField()
            }
        }
    }
    
    func addTargetToTextField() {
        commentTextField.addTarget(self, action: #selector(textFieldDidChanged), for: UIControl.Event.editingChanged)
    }
    
    @objc func textFieldDidChanged() {
        let isText = commentTextField.text?.count ?? 0 > 0
        
        if isText {
            sendButton.setTitleColor(.blue, for: .normal)
            sendButton.isEnabled = true
        } else {
            sendButton.setTitleColor(.lightGray, for: .normal)
            sendButton.isEnabled = false
        }
    }
    
    func clearTextField() {
        commentTextField.text = ""
        sendButton.isEnabled = false
        sendButton.setTitleColor(.lightGray, for: UIControl.State.normal)
    }
    
    // MARK: - Load Comments
    func loadComments() {
        guard let postID = post?.id else { return }
        let postCommentRef = Database.database().reference().child("assignedPostComments").child(postID)
        
        postCommentRef.observe(.childAdded) { snapshot in
            let commentRef = Database.database().reference().child("comments").child(snapshot.key)
            commentRef.observeSingleEvent(of: .value) { snapshot in
                guard let commentDic = snapshot.value as? [String : Any] else { return }
                let comment = CommentModel(dictionary: commentDic)
                
                guard let userID = comment.userID else { return }
                
                self.fetchUser(userID: userID) {
                    self.comments.append(comment)
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: Fetch User
    func fetchUser(userID: String, completed: @escaping () -> Void) {
        let userRef = Database.database().reference().child("users").child(userID)
        userRef.observeSingleEvent(of: .value) { snapshot in
            guard let userDic = snapshot.value as? [String : Any] else { return }
            let loadedUser = UserModel(userDictionary: userDic)
            self.users.append(loadedUser)
            completed()
        }
    }
    
    // MARK - Keyboard/Textfield Float Animation
    @objc func keyboardWillShow(_ notification: NSNotification) {
        let keyboardFrame = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        UIView.animate(withDuration: 0.1) {
            self.bottomConstraint.constant = keyboardFrame!.height
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        UIView.animate(withDuration: 0.2) {
            self.bottomConstraint.constant = 0
            self.view.layoutIfNeeded()
        }
    }
    

}

extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Comments: \(comments.count)")
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as! CommentTableViewCell
        cell.comment = comments[indexPath.row]
        cell.user = users[indexPath.row]
        
        return cell
    }
}
