//
//  ImageCaptureViewController.swift
//  PIEMONS
//
//  Created by Ankush Dhawan on 3/17/22.
//

import UIKit
import AVFoundation


class ImageCaptureViewController: UIViewController {
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var imageCaptureView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureButton.setTitle("", for: .normal)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToUploadimage"{
            let uploadObj = segue.destination as! UploadPictureViewController
            uploadObj.delegate = self
        }
    }
    @IBAction func imageCaptureButtonTapped(_ sender: Any) {
    // checkCameraAccess()
        self.performSegue(withIdentifier: "navigateToUploadimage", sender: nil)
}
    func openCamera(){
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }else{
            print("Camera is not available")
    }
        
    }
}
extension ImageCaptureViewController:UploadPictureViewControllerDelegate{
    func getImage(selectedImage: UIImage) {
        imageCaptureView.image = selectedImage
    }
    
    
}
extension ImageCaptureViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        
    }
}
