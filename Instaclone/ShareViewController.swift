//
//  ShareViewController.swift
//  Instaclone
//
//  Created by Karsten Krause on 04.01.21.
//

import UIKit
import ProgressHUD
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class ShareViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate {

    // MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var abortButton: UIButton!
    
    // MARK: - Properties
    var selectedImage: UIImage? {
        didSet {
            setupButtonsImageSelected()
        }
    }
    
    
    // MARK: - View Lifecykle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Teilen"
        addTapGestureToImageView()
        setupInitialButtons()
        
        postTextView.delegate = self
        postTextView.text = "Bildunterschrift verfassen ..."
        postTextView.textColor = .lightGray
        
        setInitialTextField()
        
    }
    
    
    // MARK: - Methods
    func setupInitialButtons() {
        shareButton.setTitleColor(UIColor(white: 1.0, alpha: 0.5), for: .normal)
        shareButton.isEnabled = false
        shareButton.layer.cornerRadius = 5
        shareButton.backgroundColor = UIColor(red: 0, green: 0.6, blue: 1.0, alpha: 0.4)
        
        abortButton.setTitleColor(UIColor(white: 1.0, alpha: 0.6), for: .normal)
        abortButton.isEnabled = false
        abortButton.layer.cornerRadius = 5
        abortButton.backgroundColor = UIColor(named: "oppositeBackground")?.withAlphaComponent(0.1)
    }
    
    func setupButtonsImageSelected() {
        let imageSelected = selectedImage != nil
        if imageSelected {
            shareButton.setTitleColor(.white, for: .normal)
            shareButton.isEnabled = true
            shareButton.layer.cornerRadius = 5
            shareButton.backgroundColor = UIColor(red: 0, green: 0.6, blue: 1.0, alpha: 1)
            
            abortButton.setTitleColor(.white, for: .normal)
            abortButton.isEnabled = true
            abortButton.layer.cornerRadius = 5
            abortButton.backgroundColor = UIColor(named: "oppositeBackground")?.withAlphaComponent(0.2)
        }
    }
    
    func reset() {
        selectedImage = nil
        postTextView.text = ""
        postImageView.image = UIImage(named: "placeholder")
        setupInitialButtons()
        setInitialTextField()
    }
    
    // MARK: TextField Placeholder
    func setInitialTextField() {
        postTextView.delegate = self
        postTextView.text = "Bildunterschrift verfassen ..."
        postTextView.textColor = .lightGray
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor(named: "oppositeBackground")
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Bildunterschrift verfassen ..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: choose photo
    func addTapGestureToImageView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSelectPhoto))
        postImageView.addGestureRecognizer(tapGesture)
        postImageView.isUserInteractionEnabled = true
    }
    
    @objc func handleSelectPhoto() {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        present(pickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.cropRect] as? UIImage {
            postImageView.image = editedImage
            selectedImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            postImageView.image = originalImage
            selectedImage = originalImage
        }
        dismiss(animated: true, completion: nil)
    }

    
    // MARK: - Actions
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        ProgressHUD.show()
        guard let image = selectedImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        let imageID = NSUUID().uuidString
        
        let storageRef = Storage.storage().reference().child("posts").child(imageID)
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if error != nil {
                ProgressHUD.showError("Fehler beim Hochladen des Bildes")
                return
            }
            storageRef.downloadURL { (url, error) in
                if error != nil {
                    return
                }
                guard let imageUrl = url?.absoluteString else { return }
                self.uploadPostToDatabase(imageUrl: imageUrl)
            }
        }
    }
    
    func uploadPostToDatabase(imageUrl: String) {
        let databaseRef = Database.database().reference().child("posts")
        let newPostID = databaseRef.childByAutoId().key
        
        guard let postID = newPostID else { return }
        let newPostRef = databaseRef.child(postID)
        
        guard let currentUserID = Auth.auth().currentUser?.uid else { return }
        let postDictionary = ["userID": currentUserID, "imageURL" : imageUrl, "postDescription" : postTextView.text!] as [String : Any]
        
        newPostRef.setValue(postDictionary) { (error, ref) in
            if error != nil {
                ProgressHUD.showError("Daten konnten nicht hochgeladen werden")
                return
            }
            ProgressHUD.showSuccess()
            self.reset()
            self.setupInitialButtons()
            self.tabBarController?.selectedIndex = 0
            
        }
    }
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
        reset()
    }
    
    // MARK: Dismiss Keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}
