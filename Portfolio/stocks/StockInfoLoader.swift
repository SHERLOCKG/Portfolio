//
//  File.swift
//  Portfolio
//
//  Created by 杨杰 on 2017/9/16.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import Foundation
import Alamofire
import ReactiveSwift
import Result

//protocol StockInfoLoaderDelegate : class{
//    func didLoadStockInfos(stocks : [Stock])
//}

enum TimeSection {
    case premaket
    case trading
    case rest
    case aftermaket
    
    static func recent() -> TimeSection {
        return .premaket
    }
}

class StockInfoLoader {
    static let instance = StockInfoLoader()
    
    private var stockCodes : [String] = []
    private var stocks : [Stock]?
    private var timer : DispatchSourceTimer?
    private var refreshInteval : TimeInterval = 0
    private let stockInfos = NSArray(contentsOfFile:Bundle.main.path(forResource: "stocks.plist", ofType:nil)!)
    
    private var startTrading : Date? = nil
    private var endTrading : Date? = nil
    private var rest1 : Date? = nil
    private var rest2 : Date? = nil
    
    private var urlString : String
    
    let (delegateSinal, observer) = Signal<[Stock], NoError>.pipe()
    
    private init() {
        urlString = "http://hq.sinajs.cn/list="
        for item in stockInfos! {
            let dic = item as! Dictionary<String, String>
            urlString.append(dic["type"]!)
            urlString.append(dic["num"]!)
            urlString.append(",")
            stockCodes.append(dic["num"]!)
        }
        
        self.setTradingTimePoints()
    }
    
    func loadStocksInfos(){
        if timer == nil {
            timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
            self.refreshInteval = self.supposedTimeSectionValue()
            timer?.scheduleRepeating(deadline: .now(), interval: .seconds(Int(self.refreshInteval)))
        }

        timer!.setEventHandler(handler: {
            [weak self] in
            self?.timer!.suspend()

            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = true
            }

            Alamofire.request((self?.urlString)!).responseString(){
                [weak self] response in
                if let value = response.result.value{
                    self!.generateStocks(value: value)
                    self!.observer.send(value: (self!.stocks)!)
                }
                UIApplication.shared.isNetworkActivityIndicatorVisible = false

                let a = self!.supposedTimeSectionValue()
                if a != self!.refreshInteval{
                    self!.timer!.cancel()
                    self!.timer!.activate()
                    self!.timer!.scheduleRepeating(deadline: .now(), interval: .seconds(Int(a)))
                    self!.refreshInteval = a
                }

                self?.timer!.resume()
            }
        })
        timer!.resume()
    }
    
    /// 股票信息转化为模型stock
    ///
    /// - Parameter value: 请求下来的股票信息字符串
    private func generateStocks(value : String){
        let stockStrings = value.components(separatedBy:";")
        var i = 0
        
        self.stocks = []
        for item in stockStrings {
            if i > 19 {
                break
            }
            let stock = Stock(stockInfoString: item, stockCode : stockCodes[i])
            
            self.stocks!.append(stock)
            i = i + 1
        }
    }
    
    /// 计算A股加以时间点
    private func setTradingTimePoints() {
        let date = Date()
        let zone = TimeZone.current
        let zoneInterval = zone.secondsFromGMT(for: date)
        
        let caledar = Calendar.current
        let dateComponenents = caledar.dateComponents([.year,.month,.day], from: Date())
        let year = dateComponenents.year!
        let month = dateComponenents.month!
        let day = dateComponenents.day!
        
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = "YYYY-MM-dd-HH-mm"
        let startTradingTimeString = "\(String(describing: year))-\(String(describing: month))-\(String(describing: day))-09-30"
        let rest1String = "\(String(describing: year))-\(String(describing: month))-\(String(describing: day))-11-30"
        let rest2String = "\(String(describing: year))-\(String(describing: month))-\(String(describing: day))-13-00"
        let endTradingTimeString = "\(String(describing: year))-\(String(describing: month))-\(String(describing: day))-15-00"
        startTrading = dateFormater.date(from: startTradingTimeString)!.addingTimeInterval(TimeInterval(zoneInterval))
        rest1 = dateFormater.date(from: rest1String)!.addingTimeInterval(TimeInterval(zoneInterval))
        rest2 = dateFormater.date(from: rest2String)!.addingTimeInterval(TimeInterval(zoneInterval))
        endTrading = dateFormater.date(from: endTradingTimeString)!.addingTimeInterval(TimeInterval(zoneInterval))
    }
    
    /// 根据不同的交易时间得出股票信息刷新间隔
    ///
    /// - Returns: 股票信息刷新间隔
    private func supposedTimeSectionValue() -> TimeInterval {
        let date = Date()
        let zone = TimeZone.current
        let zoneInterval = zone.secondsFromGMT(for: date)
        let localDate = date.addingTimeInterval(TimeInterval(zoneInterval))
        
        let interval : TimeInterval?
        if localDate < startTrading! {
            interval = startTrading!.timeIntervalSinceReferenceDate - localDate.timeIntervalSinceReferenceDate
        }else if localDate >= startTrading! && localDate < rest1!{
            interval = 10
        }else if localDate >= rest1! && localDate < rest2!{
            interval = rest2!.timeIntervalSinceReferenceDate - localDate.timeIntervalSinceReferenceDate
        }else if localDate >= rest2! && localDate < endTrading!{
            interval = 10
        }else{
            interval = startTrading!.addingTimeInterval(TimeInterval(zoneInterval * 3)).timeIntervalSinceReferenceDate - localDate.timeIntervalSinceReferenceDate
        }
        
        return interval!
    }
}

