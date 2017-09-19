//
//  stock.swift
//  Portfolio
//
//  Created by YangJie on 2017/9/13.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import Foundation

struct Stock{
    var stockInfoString : String?
    var stockName : String?
    var stockCode : String?
    var stockPrice : Float
    var stockPriceScope : Float
    var isSuspended : Bool
    
    var stockPriceString : String {
        get{
            return String(format: "%.2f", self.stockPrice)
        }
    }
    var stockPriceScopeString : String {
        get{
            if self.stockPriceScope > 0{
                return String(format: "+%.2f", self.stockPriceScope * 100) + "%"
            }else{
                return String(format: "%.2f", self.stockPriceScope * 100) + "%"
            }
        }
    }
    
    init(stockInfoString : String, stockCode : String) {
        self.stockInfoString = stockInfoString
        self.stockCode = stockCode
        let stockData = self.stockInfoString!.components(separatedBy:"\"")[1].components(separatedBy:",")
        self.stockName = stockData[0]
        if Float(stockData[1]) == 0 {
            self.stockPrice = Float(stockData[2])!
            self.stockPriceScope = 0
            self.isSuspended = true
        }else{
            self.stockPrice = Float(stockData[3])!
            self.stockPriceScope = (Float(stockData[3])! - Float(stockData[2])!) / Float(stockData[2])!
            self.isSuspended = false
        }
//        analysis()
    }
    
    init(stockName : String, stockCode : String, stockPrice : Float, stockPriceScope : Float) {
        self.stockName = stockName
        self.stockCode = stockCode
        self.stockPrice = stockPrice
        self.stockPriceScope = stockPriceScope
        self.isSuspended = false
    }
    
//    mutating func analysis(){
//        let stockData = self.stockInfoString!.components(separatedBy:"\"")[1].components(separatedBy:",")
//        self.stockName = stockData[0]
//        self.stockPrice = Float(stockData[3])!
//        self.stockPriceScope = (Float(stockData[3])! - Float(stockData[2])!) / Float(stockData[2])!
//    }
    
}
