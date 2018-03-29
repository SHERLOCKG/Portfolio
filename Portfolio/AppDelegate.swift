//
//  AppDelegate.swift
//  Portfolio
//
//  Created by YangJie on 2017/9/11.
//  Copyright © 2017年 YangJie. All rights reserved.
//

import UIKit
import ReactiveCocoa
import ReactiveSwift
import Alamofire
import Security

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
//    let a = Sequence<Int>()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.setWholeCharactor()
        var _:String? = nil
        var asss = Array<String>()
        asss.reserveCapacity(7)
//        Float
        var dic = [String : String]()
        dic.updateValue("sdsd", forKey: "sxsd")
        let arr:Set<String> = ["sdsdsd"]
        _ = arr.union(arr)
        _ = arr.intersection(arr)
        _ = arr.isSubset(of: arr)
        _ = arr.intersection(arr)
        let a = arr.map { (aa:String) -> Int in
            return aa.count
        }
        let  s = ["sdsd", "asdsds"]
        _ = s.map { $0 + $0
        }
        for ss in s where ss.count == 1 {
            print("sdsd")
        }
        if (window?.isKind(of: UIView.self))!{
//            _ = type(of: self).init()
        }
        
        s.index(of: "qw12")
        s.index { $0.first == "q"
        }
        s.contains { $0.count > 10
        }
        s.reduce(2) { $0 + $1.count
        }
        
        let constant = Property<Int>(value : 1)
        print("intinal value is \(constant.value)")
        constant.producer.startWithValues { (value) in
            print("recieve producer value \(value)")
        }
        constant.signal.observeValues { (value) in
            print("recieve singal value \(value)")
        }
        
        print("a = \(a)")
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func setWholeCharactor(){
        UINavigationBar.appearance().tintColor = UIColor(displayP3Red: 0.218, green: 0.5625, blue: 0.973, alpha: 1)
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barStyle = .black
        UINavigationBar.appearance().barTintColor = UIColor(displayP3Red: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().barTintColor = UIColor(displayP3Red: 0.15, green: 0.15, blue: 0.2, alpha: 1)
        UITabBar.appearance().tintColor = UIColor(displayP3Red: 0.218, green: 0.5625, blue: 0.973, alpha: 1)
    }
    
    func setHTTPSAuthentication(){
        //认证相关设置
        let manager = SessionManager.default
        manager.delegate.sessionDidReceiveChallenge = { session, challenge in
            //认证服务器证书
            if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodServerTrust {
                print("服务端证书认证！")
                let serverTrust:SecTrust = challenge.protectionSpace.serverTrust!
                let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0)!
                let remoteCertificateData
                    = CFBridgingRetain(SecCertificateCopyData(certificate))!
                let cerPath = Bundle.main.path(forResource: "tomcat", ofType: "cer")!
                let cerUrl = URL(fileURLWithPath:cerPath)
                let localCertificateData = try! Data(contentsOf: cerUrl)
                
                if (remoteCertificateData.isEqual(localCertificateData) == true) {
                    
                    let credential = URLCredential(trust: serverTrust)
                    challenge.sender?.use(credential, for: challenge)
                    return (URLSession.AuthChallengeDisposition.useCredential,
                            URLCredential(trust: challenge.protectionSpace.serverTrust!))
                    
                } else {
                    return (.cancelAuthenticationChallenge, nil)
                }
            }
                //认证客户端证书
            else if challenge.protectionSpace.authenticationMethod
                == NSURLAuthenticationMethodClientCertificate {
                print("客户端证书认证！")
                //获取客户端证书相关信息
                let identityAndTrust:IdentityAndTrust = self.extractIdentity();
                
                let urlCredential:URLCredential = URLCredential(
                    identity: identityAndTrust.identityRef,
                    certificates: identityAndTrust.certArray as? [AnyObject],
                    persistence: URLCredential.Persistence.forSession);
                
                return (.useCredential, urlCredential);
            }
                // 其它情况（不接受认证）
            else {
                print("其它情况（不接受认证）")
                return (.cancelAuthenticationChallenge, nil)
            }
        }
    }
    
    //获取客户端证书相关信息
    func extractIdentity() -> IdentityAndTrust {
        var identityAndTrust:IdentityAndTrust!
        var securityError:OSStatus = errSecSuccess
        
        let path: String = Bundle.main.path(forResource: "mykey", ofType: "p12")!
        let PKCS12Data = NSData(contentsOfFile:path)!
        let key : NSString = kSecImportExportPassphrase as NSString
        let options : NSDictionary = [key : "123456"] //客户端证书密码
        //create variable for holding security information
        //var privateKeyRef: SecKeyRef? = nil
        
        var items : CFArray?
        
        securityError = SecPKCS12Import(PKCS12Data, options, &items)
        
        if securityError == errSecSuccess {
            let certItems:CFArray = items as CFArray!;
            let certItemsArray:Array = certItems as Array
            let dict:AnyObject? = certItemsArray.first;
            if let certEntry:Dictionary = dict as? Dictionary<String, AnyObject> {
                // grab the identity
                let identityPointer:AnyObject? = certEntry["identity"];
                let secIdentityRef:SecIdentity = identityPointer as! SecIdentity!
                print("\(String(describing: identityPointer))  :::: \(secIdentityRef)")
                // grab the trust
                let trustPointer:AnyObject? = certEntry["trust"]
                let trustRef:SecTrust = trustPointer as! SecTrust
                print("\(String(describing: trustPointer))  :::: \(trustRef)")
                // grab the cert
                let chainPointer:AnyObject? = certEntry["chain"]
                identityAndTrust = IdentityAndTrust(identityRef: secIdentityRef,
                                                    trust: trustRef, certArray:  chainPointer!)
            }
        }
        return identityAndTrust;
    }
    
    struct IdentityAndTrust {
        var identityRef:SecIdentity
        var trust:SecTrust
        var certArray:AnyObject
    }
}
typealias myarray = Array
typealias a = Collection

extension myarray where Element == String{
    
}
extension Collection{
    
}
extension Sequence{
    
}

