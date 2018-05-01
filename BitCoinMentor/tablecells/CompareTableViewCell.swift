//
//  CompareTableViewCell.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 01/05/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit

class CompareTableViewCell: UITableViewCell {
    
    @IBOutlet weak var intervalo: UILabel!
    @IBOutlet weak var precoBinance: UILabel!
    @IBOutlet weak var porcentagemBinance: UILabel!
    @IBOutlet weak var precoMercadoBitcoin: UILabel!
    @IBOutlet weak var porcentagemMercadoBitcoin: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
