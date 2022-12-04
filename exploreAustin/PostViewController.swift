//
//  PostViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/20/22.
//

import UIKit
import AVFoundation
import FirebaseAuth

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var currUID = Auth.auth().currentUser?.email
    let postImagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var postBio: UITextField!
    @IBOutlet weak var postTags: UITextField!
    
    var username:String = ""
    var profilePhoto:UIImage!
    
    override func viewWillAppear(_ animated: Bool){
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        postImagePicker.delegate = self
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as! UIImage
        selectedImageView.contentMode = .scaleAspectFit
        selectedImageView.image = selectedImage
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }

    @IBAction func libraryBtnHit(_ sender: Any) {
        postImagePicker.sourceType = .photoLibrary
        present(postImagePicker,animated: true)
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
            
            postImagePicker.sourceType = .camera
            postImagePicker.cameraCaptureMode = .photo
            
            present(postImagePicker,animated: true)
            
        }else{
            print("no rear camera")
            return
        }
    }
    
    @IBAction func postBtnHit(_ sender: Any) {
        if let postImage = selectedImageView.image {
            print("posting...")
    
            
            createPost(image: postImage, profImage: self.profilePhoto, bio: postBio.text!, username: username, email: currUID!,tags:self.postTags.text!)
            
            //update current data struct
            let postData = fetchPostCdAsArray(user: currUid!)
            currUserPosts = postData.0
            currPosts = postData.1
            
            
            let pageVC = storyBoard.instantiateViewController(withIdentifier: "pageVC") as! PageViewController
            pageVC.isModalInPresentation = true
            pageVC.modalPresentationStyle = .fullScreen
            pageVC.userPage = currUID!
            self.present(pageVC, animated: true,completion: nil)
        }else{
            print("select image.")
        }
        
    }
    
    func formatTags(){
        
    }
}
