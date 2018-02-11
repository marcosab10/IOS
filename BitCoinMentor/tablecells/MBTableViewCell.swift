//
//  MBTableViewCell.swift
//  BitCoinMentor
//
//  Created by Marcos Faria on 31/01/18.
//  Copyright © 2018 Marcos Faria. All rights reserved.
//

import UIKit

class MBTableViewCell: UITableViewCell {

    @IBOutlet weak var compraQuantidadeLabel: UILabel!
    @IBOutlet weak var compraPrecoLabel: UILabel!
    
    @IBOutlet weak var vendaQuantidadeLabel: UILabel!
    @IBOutlet weak var vendaPrecoLabel: UILabel!
    
    @IBOutlet weak var negociadoPrecoLabel: UILabel!
    @IBOutlet weak var negociadoQuantidadeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
