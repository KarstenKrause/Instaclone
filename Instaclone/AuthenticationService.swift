//
//  AuthenticationService.swift
//  Instaclone
//
//  Created by Karsten Krause on 18.01.21.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage

class AuthenticationService {
    
    
    /// Login to an account with email and password.
    /// - Parameters:
    ///   - email: email address of an user
    ///   - password: password of an user
    ///   - onSuccess: closure that will be executed after the login succeed
    ///   - onError: closure that will be executed after the login failed
    static func signIn(email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ error: String?) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { (data, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    
    
    /// Determines whether a user is already logged in.
    /// - Parameter onSuccess: closure that will be executed after a logged in user was successfully detected.
    static func autoSignIn(onSuccess: @escaping() -> Void) {
        if Auth.auth().currentUser != nil {
            DispatchQueue.main.async {
                Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                    onSuccess()
                }
            }
        }
    }
    
    static func logout(onSuccess: @escaping() -> Void, onError: @escaping(_ error: String?) -> Void) {
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            onError(logoutError.localizedDescription)
        }
        onSuccess()
    }
    
    
    /// User Registration with email, username and password.
    /// - Parameters:
    ///   - username: username of an user
    ///   - email: email address of an user
    ///   - password: password of an user
    ///   - onSuccess: closure that will be executed after the registration succeed
    ///   - onError: closure that will be executed after the registration failed
    static func createUser(username: String, email: String, password: String, onSuccess: @escaping() -> Void, onError: @escaping(_ error: String?) -> Void) {
        
        // Default Database Entries
        let profileImage = UIImage(named: "default_profile_m.jpg")!
        let name = ""
        let userDescription = ""
        
        Auth.auth().createUser(withEmail: email, password: password) { (data, error) in
            if let err = error {
                onError(err.localizedDescription)
                return
            }
            
            guard let uid = data?.user.uid else { return }
            self.uploadUserData(email: email, userId: uid, username: username, name: name, userDescription: userDescription, profileImage: profileImage, onSuccess: onSuccess)
        }
    }
    
    
    /// Uploads  datas of a user into the firebase realtimedatabase.
    /// - Parameters:
    ///   - email: emai address of an user
    ///   - userId: userID of an user
    ///   - username: username of an user
    ///   - name: name of an user
    ///   - userDescription: description of an useraccount
    ///   - profileImage: profile image of an user
    ///   - onSuccess: closure that will be executed after the data upload succeed
    static func uploadUserData(email: String, userId: String, username: String, name: String, userDescription: String, profileImage: UIImage, onSuccess: @escaping() -> Void) {
        
        let storageRef = Storage.storage().reference().child("profileImage").child(userId)
        
        guard let uploadImage = profileImage.jpegData(compressionQuality: 0.9) else { return }
        
        storageRef.putData(uploadImage, metadata: nil) { (metadata, error) in
            if error != nil { return }
            
            storageRef.downloadURL { (url, error) in
                if error != nil { return }
                
                let profileImageURL = url?.absoluteString
                let ref = Database.database().reference().child("users").child(userId)
                ref.setValue(["email" : email, "name": name, "profilImage_URL": profileImageURL ?? "no picture available", "userDescription": userDescription, "userID" : userId, "username" : username])
                
                onSuccess()
            }
            
        }
    }
    
    
}
