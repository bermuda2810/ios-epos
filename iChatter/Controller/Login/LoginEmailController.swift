//
//  LoginEmailController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 6/10/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

class LoginEmailController: BaseViewController {

    override var titleNavigation: String? {
        return "Login"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.isHidden = false
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
