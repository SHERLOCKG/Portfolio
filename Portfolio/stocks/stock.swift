//
//  stock.swift
//  Portfolio
//
//  Created by YangJie on 2017/9/13.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import Foundation

class Stock{
    var stockInforString : String?
    
    var stockName : String?
    var srockCode : String?
    var stockPrice : Int16?
    var stockProceScope : Float?
    
    init(stockInforS : String) {
        stockInforString = stockInforS
        if stockInforString != nil{
            self.analysis()
        }
    }
    
    func analysis(){
        
    }
}
