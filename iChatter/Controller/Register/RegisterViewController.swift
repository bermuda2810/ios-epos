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
        self.showRegisterSuccess()
    }
    
    private func showRegisterSuccess() {
        if let username = edtUsername.text,  let password = edtPassword.text, let retypPass = edtRetypePassword.text {
            performSegue(withIdentifier: "segueRegisterSuccess", sender: nil)
        }
    }
    


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueRegisterSuccess" {
            let destVC = segue.destination as! RegisterSuccessController
            destVC.username = self.edtUsername.text! as String
        }
        
    }

}
