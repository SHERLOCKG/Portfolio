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
import ReactiveCocoa
import ReactiveSwift
import Result

class StocksViewController: UIViewController {
    let stockViewModel = StockViewModel()
    var editBarItem: UIBarButtonItem? = nil
    var longPressCell : StocksTableViewCell?
    
    fileprivate lazy var tableView : UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.delaysContentTouches = true
        tableView.register(StocksTableViewCell.self, forCellReuseIdentifier: "CELL")
        
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
        self.stockViewModel.updateCellsBlock = {
            self.tableView.reloadData()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.addObserver(self.stockViewModel, forKeyPath: "isEditing", options: .new, context: &myContext)
        tableView.reactive.signal(forKeyPath: "isEditing").observeValues { [weak self](isEditing) in
            if let isEditing = isEditing as? Bool{
                self?.stockViewModel.isEditing = isEditing
            }else{
                fatalError("tableview.isEditing should be Bool type!")
            }
        }
        
        self.stockViewModel.loadInfo()
        NotificationCenter.default.addObserver(self, selector: .willHideMenu, name: .UIMenuControllerWillHideMenu, object: nil)
    }
    
    private func setNavigationBarItem(){
        let action = Action { () -> SignalProducer<Any, AnyError> in
            if !self.tableView.isEditing {
                self.editBarItem!.title = "完成"
                for cell in self.tableView.visibleCells {
                    (cell as? StocksTableViewCell)?.editModel(withAnimation: true)
                }
            }else{
                self.editBarItem!.title = "编辑"
                for cell in self.tableView.visibleCells {
                    (cell as? StocksTableViewCell)?.deEditModel(withAnimation: true)
                    let longPressGestureRecognizer : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: .longPress)
                    cell.addGestureRecognizer(longPressGestureRecognizer)
                }
            }
            
            self.tableView.allowsMultipleSelectionDuringEditing = !self.tableView.isEditing
            self.tableView.setEditing(!self.tableView.isEditing, animated: true)
        
            return SignalProducer.empty
        }
        
        self.editBarItem = UIBarButtonItem(title: "编辑", style: .plain, target: nil, action: nil)
        self.editBarItem!.setTitleTextAttributes([NSFontAttributeName : UIFont.systemFont(ofSize: 14)], for: .normal)
        self.editBarItem?.reactive.pressed = CocoaAction(action)
        let leftSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        leftSpaceItem.width = 7
        
        self.navigationItem.leftBarButtonItems = [leftSpaceItem,self.editBarItem!]
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
            let delete = UIMenuItem(title: "删除", action: .delete)
            let top = UIMenuItem(title: "置顶", action: .top)
            
            menuController.menuItems = [delete, top]
            var rect = cell.frame
            rect.origin.y = rect.origin.y + 13
            menuController.setTargetRect(rect, in: self.tableView)
            menuController.setMenuVisible(true, animated: true)
        }
    }
    
    @objc fileprivate func Delete(){
        print("删除")
    }
    
    @objc fileprivate func Top(){
//        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
        print("置顶")
    }
    
    @objc fileprivate func willHideMenu(){
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
        if self.stockViewModel.lastStocks != nil {
            if self.stockViewModel.lastStocks![indexPath.row].stockPrice != self.stockViewModel.stocks![indexPath.row].stockPrice{
                (cell as! StocksTableViewCell).changeStockButtonColorAnimation()
                self.stockViewModel.lastStocks![indexPath.row] = self.stockViewModel.stocks![indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {

    }
}

extension StocksViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.stockViewModel.stocks != nil {
            return (self.stockViewModel.stocks?.count)!
        }
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CELL", for: indexPath)
        (cell as! StocksTableViewCell).stock = (self.stockViewModel.stocks?[indexPath.row])!
    
        if self.tableView.isEditing {
            (cell as! StocksTableViewCell).editModel(withAnimation: false)
        }else{
            (cell as! StocksTableViewCell).deEditModel(withAnimation: false)
            if cell.gestureRecognizers == nil || cell.gestureRecognizers?.count == 0{
                let longPressGestureRecognizer : UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: .longPress)
                cell.addGestureRecognizer(longPressGestureRecognizer)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
}

private extension Selector{
    static let delete = #selector(StocksViewController.Delete)
    static let top = #selector(StocksViewController.Top)
    static let willHideMenu = #selector(StocksViewController.willHideMenu)
    static let longPress = #selector(StocksViewController.longPress(longPressGestureGecognizer:))
}
