//
//  File.swift
//  Portfolio
//
//  Created by 杨杰 on 2017/9/16.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import Foundation
import Alamofire

struct StockInfoLoader {
    func loadStocksInfos() -> [Stock]? {
        Alamofire.request(generateURLString()).responseString{
            response in
            if let value = response.result.value{
                return analysis(value: value)!
            }else{
                return nil
            }
        }
        
        return nil
    }
    
    func generateURLString () -> String{
        var urlString = "http://hq.sinajs.cn/list="
        let stockInfos = NSArray(contentsOfFile:Bundle.main.path(forResource: "stocks.plist", ofType:nil)!)
        
        for item in stockInfos! {
            let dic = item as! Dictionary<String, String>
            urlString.append(dic["type"]!)
            urlString.append(dic["num"]!)
            urlString.append(",")
        }
        
        return urlString
    }
    
    func analysis(value : String) -> [Stock]? {
        var stocks : [Stock] = []
        let stockStrings = value.components(separatedBy:";")
        for item in stockStrings {
            let stockInfoStrings = item.components(separatedBy:"\"")[1].components(separatedBy:",")
            stocks.append(Stock(stockName: "上证指数", stockCode: "000001", stockPrice: 10.78, stockPriceScope: -0.1245))
        }
    }
}
