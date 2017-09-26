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
    var editBarItem: UIBarButtonItem? = nil
    
    fileprivate lazy var tableView : UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = UIColor.black
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.delaysContentTouches = true
        
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
        self.editBarItem = UIBarButtonItem(title: "编辑", style: .plain, target: self, action: #selector(edit))
        self.editBarItem!.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 14)], for: .normal)
        let leftSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpaceItem.width = 7
        
        self.navigationItem.leftBarButtonItems = [leftSpaceItem,self.editBarItem!]
    }
    
    @objc private func edit(){
        if !self.tableView.isEditing {
            self.editBarItem!.title = "完成"
            
            for cell in self.tableView.visibleCells {
                (cell as? StocksTableViewCell)?.editModel()
            }
        }else{
            self.editBarItem!.title = "编辑"
            
            for cell in self.tableView.visibleCells {
                (cell as? StocksTableViewCell)?.deEditModel()
            }
        }
        self.tableView.allowsMultipleSelectionDuringEditing = !self.tableView.isEditing
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension StocksViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !self.tableView.isEditing{
            tableView.deselectRow(at: indexPath, animated: true)
        }
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
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.stocks?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .bottom)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        
        if !self.tableView.isEditing {
            return .delete
        }
        return .none
    }
    
    func tableView(_ tableView: UITableView, shouldShowMenuForRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, canPerformAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        if action == #selector(copy(_:)) {
            return true
        }
        return false
    }
    
    func tableView(_ tableView: UITableView, performAction action: Selector, forRowAt indexPath: IndexPath, withSender sender: Any?) {
        if action == #selector(copy(_:)) {
        }
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
        
        if self.tableView.isEditing {
            (cell as! StocksTableViewCell).editModel()
        }else{
            (cell as! StocksTableViewCell).deEditModel()
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
