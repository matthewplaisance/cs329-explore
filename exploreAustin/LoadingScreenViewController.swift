//
//  LoadingScreenViewController.swift
//  exploreAustin
//
//  Created by Robert Binning on 10/29/22.
//

import UIKit

class LoadingScreenViewController: UIViewController {

    @IBOutlet weak var loadingImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UIView.animate(
               withDuration: 3.0,
               animations: {
                   self.loadingImage.alpha = 0.0
                   
               },
               completion: { finished in
                   self.performSegue(withIdentifier: "LoadingScreenSegue", sender: self)
               }
        )
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
