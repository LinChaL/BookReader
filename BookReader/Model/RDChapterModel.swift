//
//  RDChapterModel.swift
//  BookReader
//
//  Created by linchl on 2018/6/20.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation
import CoreText

class RDChapterModel: NSObject {
    
    /// 章节内容
    var content: String = "" {
        didSet {
            rangeArray = ParserPageRange(string: content, rect: readViewFrame, attrs: RDReadConfigure.readInfo().readAttribute())
            
            pageCount = rangeArray.count
        }
    }
    
    /// 章节标题
    var title: String = ""
    
    /// 本章有多少页
    var pageCount: Int = 0
    
    /// 每一页的Range数组
    var rangeArray: [NSRange] = []
    
    /**
     内容分页
     
     - parameter string: 内容
     
     - parameter rect: 范围
     
     - parameter attrs: 文字属性
     
     - returns: 每一页的起始位置数组
     */
    private func ParserPageRange(string:String, rect:CGRect, attrs:[NSAttributedStringKey:Any]?) ->[NSRange] {
        
        // 记录
        var rangeArray:[NSRange] = []
        
        // 拼接字符串
        let attrString = NSMutableAttributedString(string: string, attributes: attrs)
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        
        let path = CGPath(rect: rect, transform: nil)
        
        var range = CFRangeMake(0, 0)
        
        var rangeOffset:NSInteger = 0
        
        repeat{
            
            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, nil)
            
            range = CTFrameGetVisibleStringRange(frame)
            
            rangeArray.append(NSMakeRange(rangeOffset, range.length))
            
            rangeOffset += range.length
            
        }while(range.location + range.length < attrString.length)
        
        return rangeArray
    }
}
