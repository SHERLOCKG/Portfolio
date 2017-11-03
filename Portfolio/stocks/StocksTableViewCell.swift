//
//  StocksTableViewCell.swift
//  Portfolio
//
//  Created by YangJie on 2017/9/12.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import UIKit

class StocksTableViewCell: UITableViewCell {
    lazy var numformat : NumberFormatter = {
        let numformat = NumberFormatter()
        numformat.numberStyle = .percent
        
        return numformat
    }()
    
    var stockPriceScopeButtonColor : UIColor?
    
    var stock : Stock? = nil {
        didSet{
            self.setSubviewFeatures()
        }
    }
    
    public let stockNameLabel : UILabel = {
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
        button.setTitleColor(.white, for: .normal)
        
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        return button
    }()
    
    init(_ stock : Stock) {
        super.init(style: .default, reuseIdentifier: "CELL")
        self.stock = stock
        
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        self.selectedBackgroundView = view
        self.backgroundColor = UIColor(displayP3Red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    override func willTransition(to state: UITableViewCellStateMask) {
        
    }
    
    override func didTransition(to state: UITableViewCellStateMask) {
        
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
            make.width.equalTo(80)
            make.height.equalTo(32)
        }
        
        self.setSubviewFeatures()
    }
    
    func setSubviewFeatures(){
        if stock != nil {
            stockNameLabel.text = stock!.stockName
            stockCodeLabel.text = stock!.stockCode
            stockPriceLabel.text = stock!.stockPriceString
            
            if stock!.isSuspended {
                stockPriceScopeButton.setTitle("停牌", for: .normal)
            }else{
                stockPriceScopeButton.setTitle(stock!.stockPriceScopeString, for: .normal)
            }
            
            if stock!.stockPriceScope > 0 {
                self.stockPriceScopeButtonColor = UIColor(displayP3Red: 0.8, green: 0.2, blue: 0.2, alpha: 0.8)
            }else if stock!.stockPriceScope < 0{
                self.stockPriceScopeButtonColor = UIColor(displayP3Red: 0, green: 1, blue: 0, alpha: 0.5)
            }else{
                self.stockPriceScopeButtonColor = UIColor(displayP3Red: 0.5, green: 0.5, blue: 0.5, alpha: 0.6)
            }
            stockPriceScopeButton.backgroundColor = self.stockPriceScopeButtonColor
        }
    }
    
    @objc private func click(){
        let _ = "swdsd"
    }
    
    func changeStockButtonColorAnimation() {
        UIView.animate(withDuration: 1.5){
            
            self.stockPriceScopeButton.backgroundColor = self.stockPriceScopeButtonColor?.withAlphaComponent(0.3)
            
            UIView.animate(withDuration: 1.5, animations: {
                self.stockPriceScopeButton.backgroundColor = self.stockPriceScopeButtonColor
            })
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        stockPriceScopeButton.backgroundColor = self.stockPriceScopeButtonColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        stockPriceScopeButton.backgroundColor = self.stockPriceScopeButtonColor
    }
}

extension StocksTableViewCell{
    func editModel(withAnimation animation : Bool){
        self.selectedBackgroundView = UIView()
        self.stockPriceScopeButton.alpha = 0
        if self.gestureRecognizers?.count != 0 && self.gestureRecognizers != nil{
            self.removeGestureRecognizer(self.gestureRecognizers![0])
        }
        if animation {
            self.setNeedsLayout()
            UIView.animate(withDuration: 1) {
                self.stockNameLabel.snp.updateConstraints({ (make) in
                    make.left.equalTo(50)
                })
            }
        }else{
            self.stockNameLabel.snp.updateConstraints({ (make) in
                make.left.equalTo(50)
            })
        }
    }
    
    func deEditModel(withAnimation animation : Bool){
        let view = UIView()
        view.backgroundColor = UIColor(displayP3Red: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        self.selectedBackgroundView = view
        
        if animation {
            self.setNeedsLayout()
            UIView.animate(withDuration: 1) {
                self.stockPriceScopeButton.alpha = 1
                self.stockNameLabel.snp.updateConstraints({ (make) in
                    make.left.equalTo(15)
                })
            }
        }else{
            UIView.animate(withDuration: 1) {
                self.stockPriceScopeButton.alpha = 1
                self.stockNameLabel.snp.updateConstraints({ (make) in
                    make.left.equalTo(15)
                })
            }
        }
    }
}
