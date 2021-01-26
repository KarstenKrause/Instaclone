//
//  PostCameraViewController.swift
//  Instaclone
//
//  Created by Karsten Krause on 25.01.21.
//

import UIKit
import AVFoundation
import ProgressHUD

class PostCameraViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var previewPhotoView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraSwitchButton: UIButton!
    
    // MARK: - Properties
    var captureSession = AVCaptureSession()
    var photoOutput = AVCapturePhotoOutput()
    
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitalButtonDedigns()
        setupCaptureSession()
        
    }
    

    // MARK: - Methods
    func setupInitalButtonDedigns() {
        saveButton.tintColor = .white
        cancelButton.tintColor = .white
        cameraButton.tintColor = .white
        cameraSwitchButton.tintColor = .white
    }
    
    
    /// Setting up the session for the camera.
    func setupCaptureSession() {
        // 1. Capture Session - quality of the captured photo
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
        
        // 2. Input
        let captureDevice = AVCaptureDevice.default(for: .video)
        do {
            guard let device = captureDevice else { return }
            let input = try AVCaptureDeviceInput(device: device)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            ProgressHUD.showError(error.localizedDescription)
        }
        
        // 3. Output
        photoOutput.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])], completionHandler: nil)
        
        if captureSession.canAddOutput(photoOutput) {
            captureSession.addOutput(photoOutput)
        }
        
        // 4. Previewlayer - presents the taken photo
        let cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraPreviewLayer.videoGravity = .resizeAspectFill
        cameraPreviewLayer.connection?.videoOrientation = .portrait
        cameraPreviewLayer.frame = view.frame
        
        view.layer.insertSublayer(cameraPreviewLayer, at: 0)
        
        // 5. Start
        captureSession.startRunning()
        
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
