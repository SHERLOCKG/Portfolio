//
//  stock.swift
//  Portfolio
//
//  Created by YangJie on 2017/9/13.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import Foundation

struct Stock{
    
    var stockName : String?
    var stockCode : String?
    var stockPrice : Float {
        set(newValue){
            stockPriceString = String(format: "%.2f", newValue)
        }
        get{
            if let f = Float(self.stockPriceString) {
                return f
            }else{
                return 0
            }
        }
    }
    var stockPriceScope : Float{
        set(newValue){
            stockPriceScopeString = String(format: "%.2f", newValue * 100) + "%"
        }
        get{
            if let f = Float(self.stockPriceScopeString) {
                return f
            }else{
                return 0
            }
        }
    }
    
    var stockPriceString : String = "--"
    var stockPriceScopeString : String = "--"
    
    init(stockName : String, stockCode : String, stockPrice : Float, stockPriceScope : Float) {
        self.stockName = stockName
        self.stockCode = stockCode
        self.stockPrice = stockPrice
        self.stockPriceScope = stockPriceScope
    }
    
//    init(stockInforString : String) {
//        self.stockInforString = stockInforString
//        if self.stockInforString != nil{
//            self.analysis()
//        }
//    }
//    
//    func analysis(){
//        
//    }
}
