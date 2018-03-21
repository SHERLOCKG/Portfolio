//
//  InformationViewController.swift
//  Portfolio
//
//  Created by YangJie on 2017/10/30.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import UIKit
import SnapKit
import WebKit

class InformationViewController: UIViewController {
    
    lazy var webView : WKWebView = {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        webView.navigationDelegate = self
        
        return webView
    }()
    
    var p = CGPoint(x: -100, y: -100)
    lazy var indicator : UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(activityIndicatorStyle: .white)
        v.hidesWhenStopped = true
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "资讯"

        self.view.addSubview(self.webView)
        self.webView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalTo(0)
        }
        
        let item = UIBarButtonItem(customView: self.indicator)
        self.navigationItem.rightBarButtonItem = item
        
        let request = URLRequest(url: URL(string: "http://3g.163.com/touch/money/subchannel/all?dataversion=A&uversion=A&version=v_standard")!)
        self.webView.load(request)
    }
    
    override func viewDidLayoutSubviews() {
        p = (window?.convert(CGPoint(x: screenWidth/2, y: screenHeight/2), to: self.view))!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension InformationViewController : WKNavigationDelegate{
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
//        self.view.addSubview(LoadingView.instance)
//        LoadingView.instance.start()
//        LoadingView.instance.center = p
        self.indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        decisionHandler(.allow)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        LoadingView.instance.stop()
//        LoadingView.instance.removeFromSuperview()
        self.indicator.stopAnimating()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
//        LoadingView.instance.stop()
//        LoadingView.instance.removeFromSuperview()
        self.indicator.stopAnimating()
    }
    
}
