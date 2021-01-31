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

    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        //tableView.rowHeight = UITableView.automaticDimension
        //tableView.estimatedRowHeight = 500
        
    }
    
    // MARK: - Methods
    func loadPosts() {
        let databasePostsRef = Database.database().reference().child("posts")
        databasePostsRef.observe(.childAdded) { (snapshot) in
            print(snapshot.childrenCount)
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        return cell
    }
    
    
}
