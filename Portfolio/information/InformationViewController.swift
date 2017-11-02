//
//  InformationViewController.swift
//  Portfolio
//
//  Created by YangJie on 2017/10/30.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import WebKit

class InformationViewController: UIViewController {
    
    lazy var webView : WKWebView = {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "资讯"

        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
        
        let request = URLRequest(url: URL(string: "http://3g.163.com/touch/money/subchannel/all?dataversion=A&uversion=A&version=v_standard")!)
        self.webView.load(request)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
