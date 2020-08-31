//
//  StockViewCell.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 8/31/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import Kingfisher

protocol StockViewCellDelegate: class {
    func onNeedLoadProfileAtIndexPath(_ indexPath : IndexPath, _ stock : Stock)
    func onChangedFavourite(_ cell : UITableViewCell, _ stock : Stock)
    func onNeedUpdateStockPrice(_ stock : Stock)
}

class StockViewCell: UITableViewCell {
    
    @IBOutlet weak var imgStock: UIImageView!
    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    @IBOutlet weak var imgFavourite: UIImageView!
    
    public static let identifier = "StockViewCell"
    
    weak var delegate : StockViewCellDelegate?
    private var indexPath : IndexPath!
    private var timer : Timer?
    public var stock : Stock!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initView()
    }
    
    func initView() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(onFavouritePressed))
        imgFavourite.addGestureRecognizer(tapGesture)
    }
    
    func bindStock(delegate : StockViewCellDelegate, indexPath : IndexPath, stock : Stock) {
        unregisterStockUpdated()
        self.stock = stock
        self.indexPath = indexPath
        registerStockUpdated()
        
        if self.delegate == nil {
            self.delegate = delegate
        }
        
        startTimer()
    
        imgStock.image = UIImage(named: "default_stock")
        lblSymbol.text = String.init(format: "%@ - %d", stock.symbol , stock.id)
        lblCompany.text = stock.name
        
        if stock.favourite == 1 {
            imgFavourite.tintColor = UIColor.green
        }else {
            imgFavourite.tintColor = UIColor.lightGray
        }
        
        loadPrice(stock)
        loadProfile(indexPath, stock)
    }
    
    private func loadPrice(_ stock : Stock) {
        lblPrice.text = String.init(format: "%.2f", stock.price)
    }
    
    private func startTimer() {
        timer?.invalidate()
        if (stock.favourite == 1) {
            timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(onRefreshPrice), userInfo: nil, repeats: true)
        }
    }
    
    private func unregisterStockUpdated() {
        NotificationCenter.default.removeObserver(self)
    }
    
    private func registerStockUpdated() {
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateStockProfile(notification:)), name: NSNotification.Name.init(("Stock-Profile-\(stock.id)")), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(onUpdateStockPrice(notification:)), name: NSNotification.Name.init(("Stock-Price-\(stock.id)")), object: nil)
    }
    
    private func loadProfile(_ indexPath : IndexPath, _ stock : Stock) {
       
        if stock.profile == nil {
            delegate?.onNeedLoadProfileAtIndexPath(indexPath, stock)
        }else {
            let url = URL(string: stock.profile?.image! ?? "")
            imgStock.kf.setImage(with: url, placeholder: UIImage(named: "default_stock"))
        }
    }
    
    @objc func onRefreshPrice() {
        self.delegate?.onNeedUpdateStockPrice(self.stock)
    }
    
    @objc func onFavouritePressed() {
        if stock?.favourite == 0 {
            stock?.favourite = 1
        }else {
            stock?.favourite = 0
        }
        delegate?.onChangedFavourite(self, stock)
    }
    
    @objc func onUpdateStockProfile(notification : Notification) {
        loadProfile(indexPath, notification.object as! Stock)
    }
    
    @objc func onUpdateStockPrice(notification : Notification) {
        loadPrice(notification.object as! Stock)
    }
}
