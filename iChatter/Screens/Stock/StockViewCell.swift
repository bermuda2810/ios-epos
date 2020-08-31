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
    func onChangedFavouriteAtIndexPath(_ indexPath : IndexPath, _ stock : Stock)
}

class StockViewCell: UITableViewCell {
    
    @IBOutlet weak var imgStock: UIImageView!
    @IBOutlet weak var lblSymbol: UILabel!
    @IBOutlet weak var lblCompany: UILabel!
    @IBOutlet weak var lblChangesPercentage: UILabel!
    @IBOutlet weak var imgFavourite: UIImageView!
    
    public static let identifier = "StockViewCell"
    
    weak var delegate : StockViewCellDelegate?
    private var indexPath : IndexPath!
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
        self.stock = stock
        self.indexPath = indexPath
        if self.delegate == nil {
            self.delegate = delegate
        }
        imgStock.image = UIImage(named: "default_stock")
        lblSymbol.text = String.init(format: "%@ - %d", stock.symbol , stock.id)
        lblCompany.text = stock.name
        if stock.favourite == 1 {
            imgFavourite.tintColor = UIColor.green
        }else {
            imgFavourite.tintColor = UIColor.lightGray
        }
        loadProfile(indexPath, stock)
    }
    
    private func loadProfile(_ indexPath : IndexPath, _ stock : Stock) {
        if stock.profile == nil {
            lblChangesPercentage.text = "- -"
            lblChangesPercentage.textColor = UIColor.lightGray
            delegate?.onNeedLoadProfileAtIndexPath(indexPath, stock)
        }else {
            let url = URL(string: stock.profile?.image! ?? "")
            imgStock.kf.setImage(with: url, placeholder: UIImage(named: "default_stock"))
        }
    }
    
    @objc func onFavouritePressed() {
        if stock?.favourite == 0 {
            stock?.favourite = 1
        }else {
            stock?.favourite = 0
        }
        delegate?.onChangedFavouriteAtIndexPath(indexPath!, stock!)
    }
}
