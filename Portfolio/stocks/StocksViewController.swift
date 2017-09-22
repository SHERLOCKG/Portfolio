//
//  StocksViewController.swift
//  Portfolio
//
//  Created by YangJie on 2017/9/12.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire

class StocksViewController: UIViewController {
    let loader = StockInfoLoader()
    
    var stocks : [Stock]?
    var lastStocks : [Stock]?
    fileprivate lazy var tableView : UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = false
        
        return tableView
    }()

    override func viewDidLoad(){
        super.viewDidLoad()
        self.title = "自选股"
        
        self.view.addSubview(self.tableView)
        tableView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
        
        self.setNavigationBarItem()
        
        self.loader.delegate = self
        self.loader.loadStocksInfos()
    }
    
    private func setNavigationBarItem(){
        let editItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(edit))
        let leftSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpaceItem.width = 7
        editItem.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 14)], for: .normal)
        self.navigationItem.leftBarButtonItems = [leftSpaceItem,editItem]
    }
    
    @objc private func edit(){
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
//        if self.tableView.isEditing {
//            self.tableView.reloadData()
//        }
        
//        for cell in self.tableView.visibleCells {
//            UIView.animate(withDuration: 1, animations: { 
//                (cell as! StocksTableViewCell).stockPriceScopeButton.snp.makeConstraints({ (make) in
//                    make.right.equalTo((cell as! StocksTableViewCell).stockPriceScopeButton.snp.left).offset(-40)
//                })
//            })
//        }
        
//        for cell in self.tableView.visibleCells {
//            
//                (cell as! StocksTableViewCell).stockPriceScopeButton.snp.makeConstraints({ (make) in
//                    make.right.equalTo((cell as! StocksTableViewCell).stockPriceScopeButton.snp.left).offset(-40)
//                })
//        }
//        
//        UIView.animate(withDuration: 1, animations: {
//            self.tableView.setNeedsDisplay()
//        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension StocksViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let color = (cell as! StocksTableViewCell).stockPriceScopeButtonColor
        
        if self.lastStocks != nil {
            if self.lastStocks![indexPath.row].stockPrice != self.stocks![indexPath.row].stockPrice{
                UIView.animate(withDuration: 1.5){
                    
                    (cell as! StocksTableViewCell).stockPriceScopeButton.backgroundColor = color?.withAlphaComponent(0.3)
                    
                    UIView.animate(withDuration: 1.5, animations: {
                        (cell as! StocksTableViewCell).stockPriceScopeButton.backgroundColor = color
                    })
                }
                self.lastStocks![indexPath.row] = self.stocks![indexPath.row]
            }
        }
        
//        if self.tableView.isEditing {
//            (cell as! StocksTableViewCell).stockPriceScopeButton.snp.makeConstraints({ (make) in
//                make.right.equalTo((cell as! StocksTableViewCell).stockPriceScopeButton.snp.left).offset(-40)
//            })
//            UIView.animate(withDuration: 1, animations: {
//                cell.setNeedsDisplay()
//            })
//        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.stocks?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }else if editingStyle == .insert{
            self.stocks?.insert(Stock(stockName: "qqqq", stockCode: "121212", stockPrice: 12.09, stockPriceScope: 0.1), at:indexPath.row)
            tableView.insertRows(at: [indexPath], with: .bottom)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row % 2 == 1 {
            return false
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        return .none
    }
}

extension StocksViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.stocks != nil {
            return (self.stocks?.count)!
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = StocksTableViewCell((self.stocks?[indexPath.row])!)
        }else{
            (cell as! StocksTableViewCell).stock = (self.stocks?[indexPath.row])!
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
}

extension StocksViewController : StockInfoLoaderDelegate {
    func didLoadStockInfos(stocks: [Stock]) {
        self.lastStocks = self.stocks
        self.stocks = stocks
        self.tableView.reloadData()
    }
}
