//
//  MyTextMessageViewCell.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 4/20/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

class OutgoingTextMessageCell: BaseMessageViewCell {

    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var lblTimestamp: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func bindData(message: BaseMessage) {
        let textMessage = message as! TextMessage
        lblContent.text = textMessage.content
    }

}
