//
//  RDReadParser.swift
//  BookReader
//
//  Created by linchl on 2018/6/22.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation
import CoreText

class RDReadParser: NSObject {
    
    class func GetReadFrameRef(content: String, attrs: [NSAttributedStringKey : Any]?, rect: CGRect) -> CTFrame {
        let attributeString = NSMutableAttributedString(string: content, attributes: attrs)
        let frameSetter = CTFramesetterCreateWithAttributedString(attributeString)
        let path = CGPath(rect: rect, transform: nil)
        let frameRef = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: 0), path, nil)
        return frameRef
    }
    
}
