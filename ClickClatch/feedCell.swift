//
//  feedCell.swift
//  InstaClone
//
//  Created by salih kocatürk on 19.06.2023.
//

import UIKit
import Firebase

class feedCell: UITableViewCell {
    
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var likebutton: UIButton!
    @IBOutlet weak var commentlabel: UILabel!
   
    @IBOutlet weak var userİmageView: UIImageView!
    
    @IBOutlet weak var maillabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func likebuttonclicked(_ sender: Any) {
    }
}
