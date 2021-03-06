//
//  String+.swift
//  BookReader
//
//  Created by linchl on 2018/6/21.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation

extension String {
    
    public var length: Int {
        return self.count
    }
    // [index, length - 1]
    func captureSubString(from index: Int) -> String {
        return self.captureSubString(from: index, to: length - 1)
    }
    
    // [0, index]
    func captureSubString(to index: Int) -> String {
        return self.captureSubString(from: 0, to: index)
    }
    
    // [from, to]
    func captureSubString(from: Int, to: Int) -> String {
        guard from >= 0, to >= from else {
            return self
        }
        let last = to > self.length - 1 ? self.length - 1 : to
//        let start = self.index(self.startIndex, offsetBy: from)
//        let end = self.index(self.startIndex, offsetBy: to)
//        return String(self[start...end])
        let str = self as NSString
        let result = str.substring(with: NSRange(location: from, length: last - from + 1))
        return result
    }
}
