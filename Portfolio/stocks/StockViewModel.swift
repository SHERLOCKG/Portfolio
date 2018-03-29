//
//  StockViewModel.swift
//  Portfolio
//
//  Created by YangJie on 2017/11/27.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import Foundation

//var myContext = 0

class StockViewModel : NSObject,Comparable{
    let loader = StockInfoLoader.instance
    
    var stocks : [Stock]?
    var lastStocks : [Stock]?
    var isEditing = false
    var updateCellsBlock : (()->())? = nil
    
    override var description: String{
        return "StockViewModel"
    }
    
    final class func < (sv1 : StockViewModel, sv2 : StockViewModel) -> Bool{
        return false
    }
    
    static func == (sv1 : StockViewModel, sv2 : StockViewModel) -> Bool{
        return true
    }
    
    override init() {
        super.init()
        self.loader.delegateSinal.observeValues {
            [weak self](stocks) in
            if !self!.isEditing {
                self!.lastStocks = self!.stocks
                self!.stocks = stocks
                if self!.updateCellsBlock != nil{
                    self!.updateCellsBlock!()
                }
            }
        }
    }
    
    func loadInfo() {
        self.loader.loadStocksInfos()
    }
}

// MARK: - 观察StockViewController的tableView的isEditing属性变化
//extension StockViewModel{
//    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
//        if context == &myContext {
//            if change?[.newKey] != nil && keyPath == "idEditing"{
//                self.isEditing = change![.newKey] as! Bool
//            }
//        }
//    }
//}

