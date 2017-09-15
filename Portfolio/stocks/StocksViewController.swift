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
        
        Alamofire.request("http://hq.sinajs.cn/list=sh600066").responseString { (response) in
            print(response.request as Any)
            print(response.response as Any)
            print(String(data: response.data!, encoding: .utf8) as Any)
            print(response.result.value as Any)
            print(response.timeline)
            print(response.metrics as Any)
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension StocksViewController:UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension StocksViewController:UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = StocksTableViewCell(Stock(stockInforString: "000001", stockName: "上证指数", stockCode: "000001", stockPrice: 10.78, stockProceScope: -0.1245))
        }
        
//        cell?.textLabel?.textColor = UIColor.white
//        cell?.textLabel?.text = "\(indexPath.row)"
        (cell as! StocksTableViewCell).stock = Stock(stockInforString: "000001", stockName: "上证指数", stockCode: "000001", stockPrice: 10.78, stockProceScope: -0.012)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 46
    }
}
