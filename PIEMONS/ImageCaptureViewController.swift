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
import FirebaseDatabase
import FirebaseStorageUI
import CoreLocation

class ImageCaptureViewController: UIViewController {
    
    @IBOutlet weak var captureButton: UIButton!
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var imageCaptureView: UIImageView!
    @IBOutlet weak var logoutButton: UIButton!
    
    var modelObj:[DisasterTypesModel] = []
    let locationManager = CLLocationManager()
    var currentAddress:String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.delegate = self
        tableview.dataSource = self
        setupUI()
        captureButton.setTitle("", for: .normal)
        logoutButton.setTitleColor(.black, for: .normal)
        logoutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        print(MotionManager.shared.accelerometer())
        print(MotionManager.shared.gyroscope())
        print(MotionManager.shared.Magnetometer())
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "navigateToUploadimage"{
            let uploadObj = segue.destination as! UploadPictureViewController
            uploadObj.delegate = self
        }
    }
    
    
    func setupUI(){
        modelObj.append(DisasterTypesModel(type: .landslide))
        modelObj.append(DisasterTypesModel(type: .flood))
        modelObj.append(DisasterTypesModel(type: .drought))
        modelObj.append(DisasterTypesModel(type: .earthquake))
        modelObj.append(DisasterTypesModel(type: .fire))
        modelObj.append(DisasterTypesModel(type: .others))
    }
    @IBAction func imageCaptureButtonTapped(_ sender: Any) {
        // checkCameraAccess()
        self.performSegue(withIdentifier: "navigateToUploadimage", sender: nil)
    }
    @IBAction func finishButtonTapped(_ sender: Any) {
        if let currentimage = imageCaptureView.image{
            uploadImage(postImage:currentimage)
        }
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
        ANLoader.showLoading("Loading", disableUI: true)
        let ref = Database.database().reference()
        let now = Date()
        currentAddress = MyLocationManager.shared.getCity()
       // var loc = MyLocationManager.shared.newLocation
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.current
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: now)
        guard let key = ref.child("databaseapp-ceed7").childByAutoId().key else { return }
        let disasterVal = modelObj.filter{$0.isSelected == true}.first
        let accel = MotionManager.shared.accelerometer()
        let gyro = MotionManager.shared.gyroscope()
        let magne = MotionManager.shared.Magnetometer()
        let latlong = MyLocationManager.shared.getLatLong()
        let post = ["disaster": disasterVal?.type.rawValue,
                    "Gyroscope": gyro,
                    "Light": "15.0",
                    "pressure":"1006.33",
                    "address": currentAddress,
                    "date":dateString,
                    "location":latlong,
                    "time":dateString,
                    "Magnometer":magne,
                    "accelerometer":accel,
                    "Temperature":"12",
                    "Humidity":"2"
                    
        ]
        let childUpdates = [key: post]
        ref.updateChildValues(childUpdates)
        let storageRef = Storage.storage().reference().child(String(key))
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        if let uploadData = postImage.jpegData(compressionQuality: 0.5) {
            storageRef.putData(uploadData, metadata: metaData) { (metadata, error) in
                if error != nil {
                    AlertUtility.showAlert(self, title: "Something went wrong.")
                    print("error")
                    ANLoader.hide()
                } else {
                    AlertUtility.showAlert(self, title: "Information uploaded successfully")
                    ANLoader.hide()
                }
            }
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
extension ImageCaptureViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelObj.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageCaptureWithOptionsTableViewCell.cellIdentifier, for: indexPath) as! ImageCaptureWithOptionsTableViewCell
        let obj = modelObj[indexPath.row]
        cell.setupUI(with: obj)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        modelObj.forEach { obj in
            obj.isSelected = false
        }
        modelObj[indexPath.item].isSelected = !modelObj[indexPath.item].isSelected
        tableView.reloadData()
    }
}


