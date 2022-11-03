//
//  LearnMoreViewController.swift
//  exploreAustin
//
//  Created by Robert Binning on 11/3/22.
//

import UIKit

class LearnMoreViewController: UIViewController {
    var delegate: UIViewController!
    var learnMoreTitle : String!
    var descriptionTextString: String = ""
    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var descriptionText: UITextView!
    
    override func viewWillAppear(_ animated: Bool) {
        titleLabel.text = learnMoreTitle
        descriptionText.text = descriptionTextString
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
