//
//  RDReadView.swift
//  BookReader
//
//  Created by linchl on 2018/6/22.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation
import UIKit

class RDReadView: UIView {
    private var frameRef: CTFrame? {
        didSet {
            guard let _ = frameRef else { return }
            setNeedsDisplay()
        }
    }
    
    var content: String = "" {
        didSet {
            guard !content.isEmpty else { return }
            frameRef = RDReadParser.GetReadFrameRef(content: content, attrs: RDReadConfigure.readInfo().readAttribute(), rect: readViewFrame)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RDReadConfigure.readInfo().readColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 绘制
    override func draw(_ rect: CGRect) {
        
        if (frameRef == nil) {return}
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.textMatrix = CGAffineTransform.identity
        
        ctx?.translateBy(x: 0, y: bounds.size.height)
        
        ctx?.scaleBy(x: 1.0, y: -1.0)
        
        CTFrameDraw(frameRef!, ctx!)
    }
}
