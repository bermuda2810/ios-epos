//
//  DetailStockViewController.swift
//  iChatter
//
//  Created by Bui Quoc Viet on 8/31/20.
//  Copyright © 2020 NAL Viet Nam. All rights reserved.
//

import UIKit
import Charts
import MultiSelectSegmentedControl
import Kingfisher
import SwiftDate

class DetailStockViewController: BaseViewController {

    @IBOutlet weak var imgStock: UIImageView!
    @IBOutlet weak var multiSegment: MultiSelectSegmentedControl!
    @IBOutlet weak var chartView: LineChartView!
    @IBOutlet weak var lblIndustry: UILabel!
    @IBOutlet weak var lblChanges: UILabel!
    @IBOutlet weak var lblSector: UILabel!
    @IBOutlet weak var lblLastDiv: UILabel!
    @IBOutlet weak var lblSymbol: UILabel!
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgFavourite: UIImageView!
    @IBOutlet weak var lblPrice: UILabel!
    
    public var stock : Stock!
    private var presenter : DetailStockPresenter!
    private var sessions : Array<Session> = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = DetailStockPresenter(self, stock)
        initSegment()
        loadStockInfo()
        showHistoryOfMonths(month: 3)
    }
    
    private func initSegment() {
        multiSegment.items = ["3 months", "6 months", "1 year", "3 years"]
        multiSegment.addTarget(self, action: #selector(onSegmentFilterChanged), for: .valueChanged)
    }
    
    @objc private func onSegmentFilterChanged() {
        var i = 0
        if (multiSegment.selectedSegmentIndex == 0) {
            i = 3
        }else if (multiSegment.selectedSegmentIndex == 1) {
            i = 6
        }else if (multiSegment.selectedSegmentIndex == 2) {
            i = 12
        }else if (multiSegment.selectedSegmentIndex == 3) {
            i = 36
        }
        self.showHistoryOfMonths(month: i)
    }
    
    private func showHistoryOfMonths(month : Int) {
        let fromDate = (Date() - month.months).toFormat("yyyy-MM-dd")
        let toDate = Date().toFormat("yyyy-MM-dd")
        presenter.requestHistoryStock(fromDate: fromDate, toDate: toDate)
    }
    
    private func loadStockInfo() {
        lblSymbol.text = stock.symbol
        lblPrice.text = String.init(format: "%.2f", stock.price)
        lblName.text = stock.name
        if stock.favourite == 1 {
            imgFavourite.tintColor = UIColor.green
        }else {
            imgFavourite.tintColor = UIColor.lightGray
        }
        if let profile = stock.profile {
            lblLastDiv.text = "\(profile.lastDiv)"
            lblSector.text = profile.sector
            lblChanges.text = String.init(format: "%.2f", profile.changes)
            lblIndustry.text = profile.industry
            let url = URL(string: profile.image ?? "")
            imgStock.kf.setImage(with: url, placeholder: UIImage(named: "default_stock"))
        }
    }
    
    func updateChart(){
        var lineChartEntry  = [ChartDataEntry]() //this is the Array that will eventually be displayed on the graph.
        
        //here is the for loop
        for i in 0..<sessions.count {
            let value = ChartDataEntry(x: Double(i), y: sessions[i].open) // here we set the X and Y status in a data chart entry
            lineChartEntry.append(value) // here we add it to the data set
        }

        let line1 = LineChartDataSet(entries: lineChartEntry, label: "Number") //Here we convert lineChartEntry to a LineChartDataSet
        line1.colors = [NSUIColor.blue] //Sets the colour to blue

        let data = LineChartData() //This is the object that will be added to the chart
        data.addDataSet(line1) //Adds the line to the dataSet
        

        chartView.data = data //finally - it adds the chart data to the chart and causes an update
        chartView.chartDescription?.text = "Stock Line chart" // Here we set the description for the graph
    }
}

extension DetailStockViewController : DetailStockView {
    func onHistoryStockLoaded(_ sessions: Array<Session>) {
        self.sessions = sessions
        self.updateChart()
    }
    
    func onStockPriceUpdated(_ stock: Stock) {
        self.stock = stock
        self.loadStockInfo()
    }
    
    func onStockProfileLoaded(_ stock: Stock) {
        
    }
}

