//
//  RDReadViewController.swift
//  BookReader
//
//  Created by linchl on 2018/6/21.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation
import UIKit

class RDReadViewController: UIViewController {
    init(_ content: String) {
        super.init(nibName: nil, bundle: nil)
//        self.view.backgroundColor = RDReadConfigure.readInfo().readColor()
        let readView = RDReadView()
        readView.content = content
        view.addSubview(readView)
        readView.frame = readTableViewFrame
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
