//
//  HomeViewController.swift
//  exploreAustin
//
//  Created by Robert Binning on 10/27/22.
//

import UIKit


class HomeViewController: UIViewController {
    
    var images : [String] = ["ZilkerPark", "MountBonnell" ]
    var imageTitles : [String] = ["Zilker Park", "Mount Bonnell", ]
    var imageDescription : [String] = ["Zilker Metropolitan Park is considered \"Austin's most-loved park.\" This 351-acre metropolitan park is home to a variety of recreation opportunities, facilities and special events for individuals and families.", "Mount Bonnell is one of the highest points in Austin at 781 feet! The peak is named for George Bonnell, who served as Commissioner of Indian Affairs for the Texas Republic."]
    var imageSources : [String] = ["austintexas.gov", "austintexas.org"]
    var imageNumber = 0
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var imageCredit: UILabel!
    
    
    override func viewWillAppear(_ animated: Bool) {
        if DarkMode.darkModeIsEnabled == true{
            overrideUserInterfaceStyle = .dark
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changePicture()
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            UIView.animate(withDuration: 1, delay: 0, options: .curveEaseOut, animations:{self.imageView.alpha = 0; self.titleLabel.alpha = 0; self.descriptionLabel.alpha = 0; self.imageCredit.alpha = 0}){_ in
                self.changePicture()
            }
        }

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
