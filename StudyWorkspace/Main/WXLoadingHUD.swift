//
//  WXLoadingHUD.swift
//  WXNetworkingSwift_Example
//
//  Created by 610582 on 2022/1/29.
//  Copyright © 2022 CocoaPods. All rights reserved.
//

import UIKit

class WXLoadingHUD: UIView {

    override init(frame: CGRect) {
        var showFrame = frame
        if frame.equalTo(.zero) {
            showFrame = CGRect(x: 0, y: 0, width: 150, height: 150)
        }
        super.init(frame: showFrame)
        initSubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    ///由子类重写覆盖
    fileprivate func initSubView() {
        backgroundColor = .clear
        addSubview(imageView)
    }
    
    lazy var imageView: UIImageView = {
        var loadingImage = UIImage(named: "loading_gif.gif")
        let path = Bundle.main.path(forResource: "loading_gif.gif", ofType: nil)
        let gifData = NSData(contentsOfFile: path!)
        if let gifData = gifData {
            loadingImage = UIImage.yy_image(withSmallGIFData: gifData as Data, scale: 3)
        }
        let imageView = UIImageView(image: loadingImage)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        return imageView
    }()
    
}
