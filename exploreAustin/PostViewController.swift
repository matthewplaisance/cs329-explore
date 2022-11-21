//
//  PostViewController.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/20/22.
//

import UIKit
import AVFoundation

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let postImagePicker = UIImagePickerController()
    
    
    @IBOutlet weak var postComment: UITextField!
    
    @IBOutlet weak var selectedImageView: UIImageView!
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
}
