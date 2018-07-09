//
//  RDUtils.swift
//  BookReader
//
//  Created by linchl on 2018/6/21.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation

class RDUtils: NSObject {
    class func encodeWithURL(url: URL) -> String {
        var content = EncodeURL(url, encoding: String.Encoding.utf8.rawValue)
        
        if content.isEmpty {
            content = EncodeURL(url, encoding: String.Encoding(rawValue: 0x80000632).rawValue)
        }
        
        if content.isEmpty {
            content = EncodeURL(url, encoding: String.Encoding(rawValue: 0x80000631).rawValue)
        }
        
        return content
    }
    
    /// 解析URL
    private class func EncodeURL(_ url:URL,encoding:UInt) ->String {
        
        do{
            return try NSString(contentsOf: url, encoding: encoding) as String
            
        }catch{}
        
        return ""
    }
}
