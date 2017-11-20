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
import FMDB

class StocksViewController: UIViewController {
    let loader = StockInfoLoader()
    
    var stocks : [Stock]?
    var lastStocks : [Stock]?
    var editBarItem: UIBarButtonItem? = nil
    var longPressCell : StocksTableViewCell?
    var longPressGestureRecognizesArray : [UILongPressGestureRecognizer]?
    
    fileprivate lazy var tableView : UITableView = {
        let tableView = UITableView()
        
        tableView.backgroundColor = .black
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(willHideMenu), name: .UIMenuControllerWillHideMenu, object: nil)
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
                (cell as? StocksTableViewCell)?.editModel(withAnimation: true)
            }
        }else{
            self.editBarItem!.title = "编辑"
            
            for cell in self.tableView.visibleCells {
                (cell as? StocksTableViewCell)?.deEditModel(withAnimation: true)
                let longPressGestureRecognizer : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
                cell.addGestureRecognizer(longPressGestureRecognizer)
            }
        }
        
        self.tableView.allowsMultipleSelectionDuringEditing = !self.tableView.isEditing
        self.tableView.setEditing(!self.tableView.isEditing, animated: true)
    }
    
    @objc fileprivate func longPress(longPressGestureGecognizer : UILongPressGestureRecognizer){
        if self.tableView.isEditing {
            return
        }
        
        let cell = longPressGestureGecognizer.view as! StocksTableViewCell
        cell.setSelected(true, animated: false)
        
        if longPressGestureGecognizer.state == .began{
            longPressCell = cell
            cell.becomeFirstResponder()
            
            let menuController = UIMenuController.shared
            let delete = UIMenuItem(title: "删除", action: #selector(Delete))
            let top = UIMenuItem(title: "置顶", action: #selector(Top))
            
            menuController.menuItems = [delete, top]
            var rect = cell.frame
            rect.origin.y = rect.origin.y + 13
            menuController.setTargetRect(rect, in: self.tableView)
            menuController.setMenuVisible(true, animated: true)
        }
    }
    
    @objc private func Delete(){
    }
    
    @objc private func Top(){
        
    }
    
    @objc private func willHideMenu(){
        longPressCell?.setSelected(false, animated: true)
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
        if self.lastStocks != nil {
            if self.lastStocks![indexPath.row].stockPrice != self.stocks![indexPath.row].stockPrice{
                (cell as! StocksTableViewCell).changeStockButtonColorAnimation()
                self.lastStocks![indexPath.row] = self.stocks![indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
    }
    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            self.stocks?.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .bottom)
//        }
//    }
//
//    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
//        return .none
//    }
    
//    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
//        if indexPath.row % 2 == 0 {
//            return false
//        }
//        return true
//    }
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
            (cell as! StocksTableViewCell).editModel(withAnimation: false)
        }else{
            (cell as! StocksTableViewCell).deEditModel(withAnimation: false)
            if cell!.gestureRecognizers == nil || cell!.gestureRecognizers?.count == 0{
                let longPressGestureRecognizer : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPress))
                cell!.addGestureRecognizer(longPressGestureRecognizer)
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
    
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
//        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexpath) in
//            print("delete")
//        }
//        deleteAction.backgroundColor = UIColor(displayP3Red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
//        let topAction = UITableViewRowAction(style: .default, title: "Toppppppppppppp") { (action, indexpath) in
//            print("Topppppppppppppp")
//        }
//        topAction.backgroundColor = UIColor(displayP3Red: 0.3, green: 0.2, blue: 0.2, alpha: 1)
//
//        return [topAction, deleteAction]
//    }
}

extension StocksViewController : StockInfoLoaderDelegate {
    func didLoadStockInfos(stocks: [Stock]) {
        if !self.tableView.isEditing {
            self.lastStocks = self.stocks
            self.stocks = stocks
            self.tableView.reloadData()
        }
    }
}
