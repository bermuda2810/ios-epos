//
//  BaseViewController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 6/8/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import JGProgressHUD

class BaseViewController: UIViewController {

    private var hud : JGProgressHUD?
    var titleNavigation : String? { return nil }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let title = titleNavigation {
            self.title = title
        }
        self.navigationController?.navigationBar.tintColor = UIColor.black // for all text on Navigation Bar
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : UIColor.black // Only for title
        ]
        // Do any additional setup after loading the view.
    }
    
    
    //MARK: - Dialog Waiting
    func showWaitingDialog() {
        hud = JGProgressHUD(style: .dark)
        hud!.textLabel.text = "Loading"
        hud!.show(in: self.view)
    }
    
    func hideWaitingDialog() {
        hud?.dismiss()
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
