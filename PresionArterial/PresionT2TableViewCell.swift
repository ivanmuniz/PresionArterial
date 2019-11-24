//
//  PresionT2TableViewCell.swift
//  PresionArterial
//
//  Created by Iván Muñiz on 16/11/19.
//  Copyright © 2019 Iván Muñiz. All rights reserved.
//

import UIKit

class PresionT2TableViewCell: UITableViewCell {

    @IBOutlet weak var lbSistolica: UILabel!
    @IBOutlet weak var lbDiastolica: UILabel!
    @IBOutlet weak var lbPulso: UILabel!
    @IBOutlet weak var lbFecha: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
