//
//  StocksTableViewCell.swift
//  Portfolio
//
//  Created by YangJie on 2017/9/12.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import UIKit

class StocksTableViewCell: UITableViewCell {
    var stock : Stock? = nil {
        didSet{
            stockNameLabel.text = stock?.stockName
            stockCodeLabel.text = stock?.stockCode
            stockPriceLabel.text = "\(stock?.stockPrice ?? 0000)"
            stockPriceScopeButton.setTitle("\(stock?.stockProceScope ?? 00.00)", for: .normal)
        }
    }
    
    private let stockNameLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white
        
        return label
    }()
    
    private let stockCodeLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.boldSystemFont(ofSize: 10)
        
        return label
    }()

    public let stockPriceLabel : UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 21)
        
        return label
    }()
    
    public let stockPriceScopeButton : UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .green
         button.setTitleColor(.white, for: .normal)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        return button
    }()
    
    init(_ stock : Stock) {
        super.init(style: .default, reuseIdentifier: "CELL")
        self.stock = stock
        
        let view = UIView()
        view.backgroundColor = UIColor(colorLiteralRed: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        self.selectedBackgroundView = view
        self.backgroundColor = UIColor.black
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setUp() {
        stockPriceScopeButton.addTarget(self, action: #selector(click), for: .touchUpInside)
        self.addSubview(stockNameLabel)
        self.addSubview(stockCodeLabel)
        self.addSubview(stockPriceLabel)
        self.addSubview(stockPriceScopeButton)
        
        stockNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(1)
            make.width.equalTo(75)
            make.height.equalTo(30)
        }
        stockCodeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(stockNameLabel)
            make.top.equalTo(stockNameLabel.snp.bottom)
            make.width.equalTo(stockNameLabel)
            make.height.equalTo(10)
        }
        
        stockPriceScopeButton.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(7)
            make.width.equalTo(70)
            make.height.equalTo(32)
        }
        
        stockPriceLabel.snp.makeConstraints { (make) in
            make.right.equalTo(stockPriceScopeButton.snp.left).offset(-15)
            make.top.equalTo(stockPriceScopeButton)
            make.width.equalTo(70)
            make.height.equalTo(32)
        }
        
        if stock != nil {
            stockNameLabel.text = stock!.stockName
            stockCodeLabel.text = stock!.stockCode
            stockPriceLabel.text = String(describing: stock!.stockPrice)
            stockPriceScopeButton.setTitle(String(describing: stock!.stockProceScope), for: .normal)
        }else{
            
        }
    }
    
    @objc private func click(){
        let _ = "swdsd"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        stockPriceScopeButton.backgroundColor = .green
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stockPriceScopeButton.backgroundColor = .green
    }

}
