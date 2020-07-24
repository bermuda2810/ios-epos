//
//  PageViewController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 7/24/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

class PageViewController: BaseViewController {
    
    @IBOutlet weak var lbl1Page: UILabel!
    var myIndex : Int = 0
    var myTitle : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lbl1Page.text = myTitle
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
