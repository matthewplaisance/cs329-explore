//
//  FriendsTableViewCell.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/25/22.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {
    
    static let id = "FriendsTableViewCell"
    
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var friendProfImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    static func nib() -> UINib {
        return UINib(nibName: self.id, bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
