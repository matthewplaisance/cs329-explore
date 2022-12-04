//
//  EventsTableViewCell.swift
//  exploreAustin
//
//  Created by Matthew Plaisance on 11/27/22.
//

import UIKit

class EventsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var loctionDateLabel: UILabel!
    @IBOutlet weak var ownerLabel: UILabel!
    
    static let id = "EventsTableViewCell"
    
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
