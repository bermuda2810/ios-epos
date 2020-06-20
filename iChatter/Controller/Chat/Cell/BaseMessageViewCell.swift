//
//  BaseMessageViewCell.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 6/19/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit


class BaseMessageViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func bindData(message : BaseMessage) {
        
    }
}
