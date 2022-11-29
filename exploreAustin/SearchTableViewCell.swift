//
//  SearchTableViewCell.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/28/22.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    
    static let id = "SearchTableViewCell"
    
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
