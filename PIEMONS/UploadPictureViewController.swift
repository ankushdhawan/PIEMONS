//
//  UploadPictureViewController.swift
//  PIEMONS
//
//  Created by Ankush Dhawan on 3/17/22.
//

import UIKit
import AVFoundation
protocol UploadPictureViewControllerDelegate{
    func getImage(selectedImage:UIImage)
}
class UploadPictureViewController: UIViewController {
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    @IBOutlet weak var cameraView: UIView!
    var activeInput: AVCaptureDeviceInput!
    let imageOutput = AVCapturePhotoOutput()
    var delegate:UploadPictureViewControllerDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()

    }
   
    override func viewWillAppear(_ animated: Bool) {
        setupSession()
        setupPreview()
        startSession()
    }
    override func viewWillDisappear(_ animated: Bool) {
      stopSession()
    }
    func setupSession() {
      captureSession.beginConfiguration()
      guard let camera = AVCaptureDevice.default(for: .video)
            else {
        return
      }
      do {
        let videoInput = try AVCaptureDeviceInput(device: camera)
          if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
          }
        //}
        if captureSession.canAddOutput(imageOutput) {
          captureSession.addOutput(imageOutput)
        }
        activeInput = videoInput
      } catch {
        print("Error setting device input: \(error)")
        return
      }
      captureSession.commitConfiguration()
    }
    func setupPreview() {
      previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
      previewLayer.frame = cameraView.bounds
      previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        cameraView.layer.addSublayer(previewLayer)
    }

    func startSession() {
      if !captureSession.isRunning {
        DispatchQueue.global(qos: .default).async { [weak self] in
          self?.captureSession.startRunning()
        }
      }
    }
    func stopSession() {
      if captureSession.isRunning {
        DispatchQueue.global(qos: .default).async { [weak self] in
          self?.captureSession.stopRunning()
        }
      }
    }
    public func capturePhoto() {
      let settings = AVCapturePhotoSettings()
      settings.isAutoRedEyeReductionEnabled = true
      imageOutput.capturePhoto(with: settings, delegate: self)
    }
    
    
    @IBAction func clickImageButtonTapped(_ sender: Any) {
        capturePhoto()
    }
    
}
extension UploadPictureViewController: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    if let error = error {
      print(error.localizedDescription)
      return
    }
      guard let photoData = photo.fileDataRepresentation() else {
      return
    }
      if let image = UIImage(data: photoData){
          self.dismiss(animated: true)
          delegate.getImage(selectedImage: image)
          
      }
      
  }
}


