//
//  NotificationTableViewCell.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/30/22.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    static let id = "NotificationTableViewCell"
    var userEmail:String!
    //var row:table
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var profilePhotoView: UIImageView!
    @IBOutlet weak var rejectBtn: UIButton!
    @IBOutlet weak var acceptBtn: UIButton!
    
    static func nib() -> UINib {
        return UINib(nibName: self.id, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        rejectBtn.titleLabel?.font =  UIFont(name: "system", size: 12)
        acceptBtn.titleLabel?.font =  UIFont(name: "system", size: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func acceptBtnHit(_ sender: Any) {
        self.rejectBtn.alpha = 0
        self.rejectBtn.isUserInteractionEnabled = false
        self.acceptBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        self.acceptBtn.setTitle("Friends!", for: .normal)
        
        acceptFriendReq(othUser: self.userEmail)
    }
    
    
    @IBAction func rejectBtnHit(_ sender: Any) {
    }
}
