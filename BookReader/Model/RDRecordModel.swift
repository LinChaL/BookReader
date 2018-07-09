//
//  RDRecordModel.swift
//  BookReader
//
//  Created by linchl on 2018/6/30.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation

class RDRecordModel: NSObject, NSCopying {
    override init() {
        super.init()
    }
    
    init(bookId: String, chapter: Int, page: Int) {
        self.bookId = bookId
        self.chapter = chapter
        self.page = page
        super.init()
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copyObject = RDRecordModel()
        copyObject.bookId = self.bookId
        copyObject.chapter = self.chapter
        copyObject.page = self.page
        return copyObject
    }
    
    /// 书ID
    var bookId: String = ""
    /// 章节
    var chapter: Int = 0
    /// 当前章节的页数
    var page: Int = 0
}
