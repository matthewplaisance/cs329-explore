//
//  HomeViewController.swift
//  exploreAustin
//
//  Created by Robert Binning on 10/27/22.
//

import UIKit
import FirebaseAuth


class HomeViewController: UIViewController {
    
    var images : [String] = ["ZilkerPark", "BartonSprings", "MountBonnell", "picture5" ]
    var imageTitles : [String] = ["Zilker Park", "Barton Springs", "Mount Bonnell", "Lady Bird Johnson Wildflower Center" ]
    var imageDescription : [String] = ["Zilker Metropolitan Park is considered \"Austin's most-loved park.\" This 351-acre metropolitan park is home to a variety of recreation opportunities, facilities and special events for individuals and families.", "Within Zilker Park's 358 acres lies one of the crown jewels of Austin - Barton Springs Pool. The pool itself measures three acres in size, and is fed from underground springs with an average temperature of 68-70 degrees, ideal for year-round swimming", "Mount Bonnell is one of the highest points in Austin at 781 feet! The peak is named for George Bonnell, who served as Commissioner of Indian Affairs for the Texas Republic.", "The Lady Bird Johnson Wildflower Center in Austin, Texas, is dedicated to inspiring the conservation of native plants. Located a quick but quiet ten miles from downtown, we are a botanical garden open to the public year-round and have become a favored venue for everything from conservation-focused conventions to beautiful weddings."]
    var imageSources : [String] = ["austintexas.gov", "austintexas.org", "austintexas.org", "wildflower.org"]
    var imageNumber = 0
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imageCredit: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        let user = Auth.auth().currentUser
        if let user = user {
          let uid = user.uid
          let email = user.email
          print(uid)
          var multiFactorString = "MultiFactor: "
          for info in user.multiFactor.enrolledFactors {
            multiFactorString += info.displayName ?? "[DispayName]"
            multiFactorString += " "
          }
        }
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }else{
            overrideUserInterfaceStyle = .light
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePicture()
        // Do any additional setup after loading the view.
    }
    
    
    func changePicture(){
        if imageNumber >= images.count{
            imageNumber = 0
        }
        imageView.image = UIImage(named: images[imageNumber])
        
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {self.imageView.alpha = 1; self.titleLabel.alpha = 1; self.descriptionLabel.alpha = 1; self.imageCredit.alpha = 1})
        titleLabel.text = imageTitles[imageNumber]
        descriptionLabel.text = imageDescription[imageNumber]
        imageCredit.text = imageSources[imageNumber]
        imageNumber += 1
    }

    @IBAction func rightArrowHit(_ sender: Any) {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations:{self.imageView.alpha = 0; self.titleLabel.alpha = 0; self.descriptionLabel.alpha = 0; self.imageCredit.alpha = 0}){_ in
            self.changePicture()
        }
    }
    
    @IBAction func leftArrowHit(_ sender: Any) {
        if imageNumber - 2 < 0{
            return
        }
        else{
            imageNumber -= 2
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations:{self.imageView.alpha = 0; self.titleLabel.alpha = 0; self.descriptionLabel.alpha = 0; self.imageCredit.alpha = 0}){_ in
                self.changePicture()
            }
        }
        
    }
}
