//
//  PostCameraViewController.swift
//  Instaclone
//
//  Created by Karsten Krause on 25.01.21.
//

import UIKit
import AVFoundation
import ProgressHUD
import Photos

class PostCameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    // MARK: - Outlets
    @IBOutlet weak var previewPhotoView: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var cameraSwitchButton: UIButton!
    
    // MARK: - Properties
    var captureSession = AVCaptureSession()
    var photoOutput = AVCapturePhotoOutput()
    
    // MARK: hide statusbar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    
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
        takePhoto()
    }
    
    /// Describes how the preview photo will be displayed
    func takePhoto() {
        let settings = AVCapturePhotoSettings()
        guard let previewFormatType = settings.availablePreviewPhotoPixelFormatTypes.first else { return }
        settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String : previewFormatType]
        photoOutput.capturePhoto(with: settings, delegate: self)
        
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation() {
            previewPhotoView.image = UIImage(data: imageData)
            saveButton.isHidden = false
            cancelButton.isHidden = false
        }
    }
    
    // MARK: Switch Camera
    @IBAction func cameraSwitchButtonTapped(_ sender: UIButton) {
        switchCamera()
    }
    
    /// Switches the camera on a device
    func switchCamera(){
        guard let input = captureSession.inputs[0] as? AVCaptureDeviceInput else { return }
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        // new device
        var newDevice: AVCaptureDevice?
        if input.device.position == .back {
            newDevice = captureDevice(with: .front)
        } else {
            newDevice = captureDevice(with: .back)
        }
        
        // new input
        var deviceInput: AVCaptureDeviceInput!
        do {
            guard let device = newDevice else { return }
            deviceInput = try AVCaptureDeviceInput(device: device)
        } catch let error {
            ProgressHUD.showError(error.localizedDescription)
        }
        
        captureSession.removeInput(input)
        captureSession.addInput(deviceInput)
    }
    
    
    /// Sets up a capture divece and returns it
    /// - Parameter position: front or back camera
    /// - Returns: a capture device
    func captureDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInDualCamera, .builtInTelephotoCamera, .builtInWideAngleCamera], mediaType: .video, position: .unspecified).devices
        
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    // MARK: Save Photo
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        savePhoto()
    }
    
    func savePhoto() {
        let libary = PHPhotoLibrary.shared()
        guard let image = previewPhotoView.image else { return }
        
        libary.performChanges {
            PHAssetChangeRequest.creationRequestForAsset(from: image)
        } completionHandler: { (success, error) in
            if error != nil {
                ProgressHUD.showError(error?.localizedDescription)
                return
            }
            ProgressHUD.showSuccess()
        }

    }
    
    // MARK: Cancel
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        cancel()
    }
    
    func cancel() {
        previewPhotoView.image = nil
        saveButton.isHidden = true
        cancelButton.isHidden = true
    }
    
    @IBAction func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
}
