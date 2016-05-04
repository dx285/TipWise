//
//  TipRateCell.swift
//  tip_helper
//
//  Created by Di on 1/29/16.
//  Copyright © 2016 Di. All rights reserved.
//

import UIKit

class TipRateCell: UITableViewCell {
    
    @IBOutlet weak var category: UILabel!
    
    @IBOutlet weak var badTipBtn: UIButton!
    @IBOutlet weak var goodTipBtn: UIButton!
    @IBOutlet weak var excTipBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    

}
