//
//  RegisterSuccessController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 6/12/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

class RegisterSuccessController: BaseViewController {
    
    @IBOutlet weak var lblNotification: UILabel!
    
    var username : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNotification.text = "Chúc mừng tài khoản \( username) !!"
    }
    
    @IBAction func onCompletePressed(_ sender: Any) {
        self.postNotificationCenter(channel: Channel.REGISTER, data: "Hello")
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
