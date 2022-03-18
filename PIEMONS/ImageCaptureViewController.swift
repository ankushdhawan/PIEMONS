//
//  ImageCaptureViewController.swift
//  PIEMONS
//
//  Created by Ankush Dhawan on 3/17/22.
//

import UIKit
import AVFoundation
import FirebaseStorage
import ANLoader
import Firebase
import FirebaseAuth

class ImageCaptureViewController: UIViewController {
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var imageCaptureView: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        captureButton.setTitle("", for: .normal)
        logoutButton.setTitleColor(.black, for: .normal)
        logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
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
    @IBAction func logoutButtonTapped(_ sender: Any) {
        AlertUtility.showAlert(self, title: "Are you sure you want to logout ?", cancelButton: "Cancel", buttons: ["OK"], actions: {(action, index) -> () in
            if index != AlertUtility.CancelButtonIndex {
                UserDefaultHelper.userToken = nil
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                      let sceneDelegate = windowScene.delegate as? SceneDelegate else {return}
                sceneDelegate.setRootViewController(scene: windowScene)
            }
        })
        
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
    
    func uploadImage(postImage:UIImage) {
        let now = Date()
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        ANLoader.showLoading("Loading", disableUI: true)
        let dateString = formatter.string(from: now)
        let storageRef = Storage.storage().reference().child("images/rivers.jpg")
        if let uploadData = postImage.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                ANLoader.hide()
                if error != nil {
                    AlertUtility.showAlert(self, title: "Something went wrong.")
                    print("error")
                } else {
                    AlertUtility.showAlert(self, title: "Image uploaded successfully")
                    //  completion((metadata?.downloadURL()?.absoluteString)!))
                    // your uploaded photo url.
                    
                    
                }
            }
        }
        
    }
    
    
}
extension ImageCaptureViewController:UploadPictureViewControllerDelegate{
    func getImage(selectedImage: UIImage) {
        imageCaptureView.image = selectedImage
        uploadImage(postImage:selectedImage)
        
    }
}
extension ImageCaptureViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
        
    }
}
