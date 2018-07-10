//
//  RDReadParser.swift
//  BookReader
//
//  Created by linchl on 2018/6/22.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation
import CoreText
import UIKit

class RDReadParser: NSObject {
    
    class func GetReadFrameRef(content: String, attrs: [NSAttributedStringKey : Any]?, rect: CGRect) -> CTFrame {
        let attributeString = NSMutableAttributedString(string: content, attributes: attrs)
        let frameSetter = CTFramesetterCreateWithAttributedString(attributeString)
        let path = CGPath(rect: rect, transform: nil)
        let frameRef = CTFramesetterCreateFrame(frameSetter, CFRange(location: 0, length: 0), path, nil)
        return frameRef
    }
    
    class func screenShot(_ view: UIView? = nil, isSave: Bool = false) -> UIImage? {
        let shot = view ?? (UIApplication.shared.keyWindow ?? UIApplication.shared.windows.first)
        guard let shotView = shot else { return nil }
        UIGraphicsBeginImageContextWithOptions(shotView.bounds.size, false, 0)
        shotView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if isSave {
            UIImageWriteToSavedPhotosAlbum(result!, nil, nil, nil)
        }
        return result
    }
    
}
