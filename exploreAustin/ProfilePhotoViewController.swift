//
//  ProfilePhotoViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/20/22.
//

import UIKit
import AVFoundation
import FirebaseAuth

//get rid of of cancel toolbar if we keep nav controller flow, but want to change it to bottom toolbar on each page like instagram
class ProfilePhotoViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var currUid = Auth.auth().currentUser?.email
    
    @IBOutlet weak var tempProfPhotoView: UIImageView!
    
    let profImagePicker = UIImagePickerController()
    
    override func viewWillAppear(_ animated: Bool){
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profImagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as! UIImage
        tempProfPhotoView.contentMode = .scaleAspectFill
        tempProfPhotoView.image = selectedImage
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
    
    @IBAction func libraryBtnHit(_ sender: Any) {
        profImagePicker.sourceType = .photoLibrary
        present(profImagePicker,animated: true)
    }
    
    
    @IBAction func cameraBtnHit(_ sender: Any) {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            
            switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: .video){
                    accessGranted in
                    guard accessGranted == true else {return}
                }
            case .authorized:
                break//continue to below code
            default:
                print("access denied")
                return
            }
            
            profImagePicker.sourceType = .camera
            profImagePicker.cameraCaptureMode = .photo
            
            present(profImagePicker,animated: true)
            
        }else{
            print("no rear camera")
            return
        }
    }
    
    

    @IBAction func saveBtnHit(_ sender: Any) {
        let profVC = storyBoard.instantiateViewController(withIdentifier: "profVC") as! ProfileViewController
        
        if let profImage = tempProfPhotoView.image {
            profVC.profImage = profImage
        }
        saveUIImage(image: tempProfPhotoView.image!, uid: currUid!)
        
        let data = fetchUserCdAsArray(user: currUid!)
        currentUserData.currUserData = data
        
        self.present(profVC, animated:true, completion:nil)
    }
    
}
