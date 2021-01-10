//
//  HomeViewController.swift
//  Instaclone
//
//  Created by Karsten Krause on 04.01.21.
//

import UIKit
import Firebase
import FirebaseAuth

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    
    
    // MARK: - Actions
    
    
    @IBAction func logoutButtonTapped(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            
        } catch let logoutError {
            print(logoutError.localizedDescription)
        }
        
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let loginVC = storyboard.instantiateViewController(identifier: "LoginVC")
        loginVC.modalPresentationStyle = .fullScreen
        loginVC.modalTransitionStyle = .crossDissolve
        present(loginVC, animated: true, completion: nil)
    }
    
   
    
}
