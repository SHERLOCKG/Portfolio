//
//  File.swift
//  Portfolio
//
//  Created by 杨杰 on 2017/9/16.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import Foundation
import Alamofire

protocol StockInfoLoaderDelegate : class{
    func didLoadStockInfos(stocks : [Stock])
}

class StockInfoLoader {
    var stockCodes : [String] = []
    var stocks : [Stock] = []
    weak var delegate : StockInfoLoaderDelegate?
    
    func loadStocksInfos(){
        Alamofire.request(generateURLString()).responseString{
            [weak self] response in
            if let value = response.result.value{
                self?.generateStocks(value: value)
                self?.delegate?.didLoadStockInfos(stocks: (self?.stocks)!)
            }
        }
    }
    
    func generateURLString () -> String{
        var urlString = "http://hq.sinajs.cn/list="
        let stockInfos = NSArray(contentsOfFile:Bundle.main.path(forResource: "stocks.plist", ofType:nil)!)
        
        for item in stockInfos! {
            let dic = item as! Dictionary<String, String>
            urlString.append(dic["type"]!)
            urlString.append(dic["num"]!)
            urlString.append(",")
            stockCodes.append(dic["num"]!)
        }
        
        return urlString
    }
    
    func generateStocks(value : String){
        let stockStrings = value.components(separatedBy:";")
        var i = 0
        
        for item in stockStrings {
            if i > 19 {
                break
            }
            let stock = Stock(stockInfoString: item, stockCode : stockCodes[i])
            self.stocks.append(stock)
            i = i + 1
        }
    }
}
