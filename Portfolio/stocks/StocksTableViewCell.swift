//
//  StocksTableViewCell.swift
//  Portfolio
//
//  Created by YangJie on 2017/9/12.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import UIKit

class StocksTableViewCell: UITableViewCell {
    
    private let stockNameLabel : UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let stockCodeLabel : UILabel = {
        let label = UILabel()
        
        return label
    }()

    public let stockPriceLabel : UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    public let stockPriceScopeButton : UIButton = {
        let button = UIButton(type: .custom)
        
        return button
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.addSubview(stockNameLabel)
        self.addSubview(stockCodeLabel)
        self.addSubview(stockPriceLabel)
        self.addSubview(stockPriceScopeButton)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
