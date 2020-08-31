//
//  RootStockViewController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 8/31/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit

class RootStockViewController: BaseViewController {
    
    private var presenter : RootStockPresenter!
    private var listStockVC : ListStockViewController?
    
    @IBOutlet weak var segmentFilter: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = RootStockPresenter(self)
        presenter.requestListStock()
    }
    
    @IBAction func onSegmentFilterChanged(_ sender: Any) {
        if segmentFilter.selectedSegmentIndex == 0 {
            listStockVC?.onFilterChanged(0)
        }else {
            listStockVC?.onFilterChanged(1)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueListStockViewController" {
            self.listStockVC = segue.destination as? ListStockViewController
        }
    }
}

extension RootStockViewController : RootStockView {
    
    func onReady() {
        print("Ready for showing Stock")
        super.hideWaitingDialog()
        self.listStockVC?.onReady()
    }
    
    func onLoadFail(_ errorCode: Int, _ errorMessage: String) {
        print("Error \(errorMessage)")
        super.hideWaitingDialog()
    }
    
    func onStartLoadStock() {
        super.showWaitingDialog()
    }
}
