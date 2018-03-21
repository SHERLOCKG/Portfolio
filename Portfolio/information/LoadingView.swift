//
//  LoadingView.swift
//  Portfolio
//
//  Created by YangJie on 2018/3/20.
//  Copyright © 2018年 YangJie. All rights reserved.
//

import UIKit

class LoadingView: UIImageView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    static let instance = LoadingView()

    let basicAnimationKey = "rotationAnimation"
    
    lazy var rotationAnimation : CABasicAnimation = {
        var animation = CABasicAnimation(keyPath: "transform.rotation.z")
        animation.duration = 0.5
        animation.toValue = 2 * Double.pi
        animation.repeatCount = .infinity
        animation.isCumulative = true
        
        return animation
    }()
    
    private convenience init(){
        self.init(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        self.image = UIImage(named: "loading")
    }
    
    private override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "loading")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.image = UIImage(named: "loading")
    }
    
    func start(){
        self.layer.add(self.rotationAnimation, forKey: basicAnimationKey)
    }
    
    func stop(){
        self.layer.removeAnimation(forKey: basicAnimationKey)
    }
}
