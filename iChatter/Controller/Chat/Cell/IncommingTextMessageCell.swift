//
//  SenderMessageViewCell.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 4/20/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

class IncommingTextMessageCell: BaseMessageViewCell {
    
    @IBOutlet weak var lblContent: UILabel!
    
    override func bindData(message : BaseMessage)  {
        let textMessage = message as! TextMessage
        lblContent.text = textMessage.content
    }
}
