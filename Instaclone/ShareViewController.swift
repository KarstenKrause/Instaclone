//
//  ShareViewController.swift
//  Instaclone
//
//  Created by Karsten Krause on 04.01.21.
//

import UIKit

class ShareViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - Outlets
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var postTextView: UITextView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var abortButton: UIButton!
    
    // MARK: - Properties
    var selectedImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Teilen"
        addTapGestureToImageView()
    }
    
    
    // MARK: - Methods
    
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
        print("Teilen getappt")
    }
    
    
    @IBAction func abortButtonTapped(_ sender: UIButton) {
        print("Abbrechen getappt")
    }
    
}
