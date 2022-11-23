//
//  FeedTableViewCell.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/22/22.
//

import UIKit

class FeedTableViewCell: UITableViewCell {
    
    static let id = "FeedTableViewCell"
    
    //register cell
    static func nib() -> UINib {
        return UINib(nibName: "FeedTableViewCell", bundle: nil)
    }
    
    
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var postImageContainer: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
