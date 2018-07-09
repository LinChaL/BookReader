//
//  RDReadModel.swift
//  BookReader
//
//  Created by linchl on 2018/6/20.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation

class RDReadModel: NSObject {
    private var resource: URL?
    var content: String = ""
    var chapterList: [RDChapterModel] = []
    var record: RDRecordModel? // 当前的章节
    
    init(resource: URL) {
        self.resource = resource
        super.init()
        content = RDUtils.encodeWithURL(url: resource)
        seperateChapter()
        guard chapterList.count > 0 else {
            return
        }
        record = RDRecordModel(bookId: "", chapter: 0, page: 0)
    }
    
    private func seperateChapter() {
        chapterList.removeAll()
        let pattern = "第[0-9一二三四五六七八九十百千]*[章回].*"
        let reg = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let match = reg?.matches(in: content, options: [], range: NSRange(location: 0, length: content.count))
        
        guard let matchs = match, matchs.count > 0 else {
            let chapter = RDChapterModel()
            chapter.content = content
            chapterList.append(chapter)
            return
        }
        
        var lastRange = NSRange(location: 0, length: 0)
        
        for item in matchs {
            guard let idx = matchs.index(of: item) else {
                continue
            }
            let range = item.range
            
            if idx == 0 {
                let chapter = RDChapterModel()
                chapter.title = "开始"
                chapter.content = content.captureSubString(to: range.location - 1)
                if chapter.content.count > 0 {
                    chapterList.append(chapter)
                }
            }
            if idx > 0 {
                let chapter = RDChapterModel()
                chapter.title = content.captureSubString(from: lastRange.location, to: lastRange.location + lastRange.length - 1)
                chapter.content = content.captureSubString(from: lastRange.location, to: range.location - 1)
                chapterList.append(chapter)
            }
            if idx == matchs.count - 1 {
                let chapter = RDChapterModel()
                chapter.title = content.captureSubString(from: range.location, to: range.location + range.length - 1)
                chapter.content = content.captureSubString(from: range.location)
                chapterList.append(chapter)
            }
            lastRange = range
        }
        
    }
}
