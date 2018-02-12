//
//  OrdemTableViewCell.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 11/02/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit

class OrdemTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coinPairLabel: UILabel!
    @IBOutlet weak var orderTypeLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var limitPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
