//
//  HomeViewController.swift
//  Instaclone
//
//  Created by Karsten Krause on 04.01.21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class HomeViewController: UIViewController {

    // MARK: - Properties
    var posts = [PostModel]()
    var users = [UserModel]()
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        loadPosts()
        print("Home geladen")
    }
    
    // MARK: - Methods
    func loadPosts() {
        activityIndicatorView.startAnimating()
        let databasePostsRef = Database.database().reference().child("posts")
        databasePostsRef.observe(.childAdded) { (snapshot) in
            guard let postDictionary = snapshot.value as? [String : Any] else { return }
            let post = PostModel(dictionary: postDictionary)
            
            guard let userID = post.userID else { return }
            self.fetchUsers(uid: userID) {
                self.posts.insert(post, at: 0)
                self.tableView.setContentOffset(CGPoint.zero, animated: true)
                self.activityIndicatorView.stopAnimating()
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Fetch Users
    func fetchUsers(uid: String, completion: @escaping () -> Void) {
        let refDatabaseUser = Database.database().reference().child("users").child(uid)
        refDatabaseUser.observe(.value) { (snapshot) in
            guard let userDictionary = snapshot.value as? [String : Any] else {return}
            let user = UserModel(userDictionary: userDictionary)
            self.users.append(user)
            completion()
        }
    }
    
    
    
    // MARK: - Actions
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        AuthenticationService.logout {
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let loginVC = storyboard.instantiateViewController(identifier: "LoginVC")
            loginVC.modalPresentationStyle = .fullScreen
            loginVC.modalTransitionStyle = .crossDissolve
            self.present(loginVC, animated: true, completion: nil)
        } onError: { (error) in
            print(error!)
        }
  
    }
    
    
    
}


// MARK: - TableView data source
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        
        cell.post = posts[indexPath.row]
        cell.user = users[indexPath.row]
        
        return cell
    }
    
}

extension HomeViewController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController.tabBarItem.tag == 1 {
            self.tableView.setContentOffset(CGPoint.zero, animated: true)
        }
    }
}
