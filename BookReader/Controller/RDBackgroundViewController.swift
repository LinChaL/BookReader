//
//  RDBackgroundViewController.swift
//  BookReader
//
//  Created by linchl on 2018/7/6.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation
import UIKit

class RDBackgroundViewController: UIViewController {
    var targetView: UIView?
    
    private var imageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.backgroundColor = RDReadConfigure.readInfo().readColor()
        imageView.frame = view.bounds
        imageView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0)
        
        guard let targetView = targetView else { return }
        
    }
}
