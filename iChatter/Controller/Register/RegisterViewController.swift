//
//  RegisterViewController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 6/10/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

class RegisterViewController: BaseViewController {
    @IBOutlet weak var edtUsername: UITextField!
    @IBOutlet weak var edtPassword: UITextField!
    @IBOutlet weak var edtRetypePassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func onRegisterPressed(_ sender: Any) {
        let parent = self.navigationController
        print("Say hello")
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
