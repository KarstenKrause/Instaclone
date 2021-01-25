//
//  PostCameraViewController.swift
//  Instaclone
//
//  Created by Karsten Krause on 25.01.21.
//

import UIKit

class PostCameraViewController: UIViewController {
    @IBOutlet weak var previewPhotoView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraSwitchButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitalButtonDedigns()
        
    }
    

    // MARK: - Methods
    func setupInitalButtonDedigns() {
        saveButton.tintColor = .white
        cancelButton.tintColor = .white
        cameraButton.tintColor = .white
        cameraSwitchButton.tintColor = .white
    }
    
    
    // MARK: - Actions
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        print("camera button tapped")
        saveButton.isHidden = false
        cancelButton.isHidden = false
    }
    
    @IBAction func cameraSwitchButtonTapped(_ sender: UIButton) {
        print("camera switchbutton tapped")
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        print("save button tapped")
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        print("cancel button tapped")
        saveButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        print("dismiss button tapped")
    }
    
    
    
    
}
