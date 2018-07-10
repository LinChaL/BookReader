//
//  RDPageViewController.swift
//  BookReader
//
//  Created by linchl on 2018/6/20.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation
import UIKit

class RDPageViewController: RDViewController {
    var resourceURL: URL?
    var readModel: RDReadModel?
    
    /// 用于区分正反面的值
    private var tempNumber: Int = 1
    /// 翻页过程中的临时record，是否更新要看翻页最终是否完成
    private var tempRecord: RDRecordModel?
    
    private var currentReadViewController: RDReadViewController?
    private var previewReadViewController: RDReadViewController?
    
    private(set) var pageViewController: UIPageViewController? {
        willSet {
            pageViewController?.view.removeFromSuperview()
            pageViewController?.removeFromParentViewController()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        guard let readModel = readModel, let record = readModel.record else { return }
        createPageController(getReadViewController(record))
    }
    
    private func createPageController(_ displayController: UIViewController?) {
        let options = [UIPageViewControllerOptionSpineLocationKey:NSNumber(value: UIPageViewControllerSpineLocation.min.rawValue as Int)]
        
        pageViewController = UIPageViewController(transitionStyle:UIPageViewControllerTransitionStyle.pageCurl,navigationOrientation:UIPageViewControllerNavigationOrientation.horizontal,options: options)
        
        pageViewController!.delegate = self
        
        pageViewController!.dataSource = self
        
        // 为了翻页背面的颜色使用
        pageViewController!.isDoubleSided = true
        
        view.insertSubview(pageViewController!.view, at: 0)
        
        addChildViewController(pageViewController!)
        
        pageViewController!.setViewControllers((displayController != nil ? [displayController!] : nil), direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
    }
    
    private func getReadViewController(_ record: RDRecordModel) -> RDReadViewController? {
        guard  let readModel = readModel else {
            return nil
        }
        
        let chapter = readModel.chapterList[record.chapter]
        let content = chapter.content
        let range = chapter.rangeArray[record.page]
        let subContent = content.captureSubString(from: range.location, to: range.location + range.length)
        return RDReadViewController(subContent)
    }
    
    private func getPreviewReadController() -> RDReadViewController? {
        guard let readModel = readModel, let currentRecord = readModel.record else {
            return nil
        }
        if currentRecord.page <= 0 && currentRecord.chapter <= 0 {
            return nil
        }
        let record = currentRecord.copy() as! RDRecordModel
        if record.page <= 0 {
            record.chapter -= 1
            record.page = readModel.chapterList[record.chapter].pageCount - 1
        } else {
            record.page -= 1
        }
        tempRecord = record
        return getReadViewController(record)
    }
    
    private func getNextReadController() -> RDReadViewController? {
        guard let readModel = readModel, let currentRecord = readModel.record else {
            return nil
        }
        if currentRecord.page >= readModel.chapterList[currentRecord.chapter].pageCount - 1 && currentRecord.chapter >= readModel.chapterList.count - 1 {
            return nil
        }
        let record = currentRecord.copy() as! RDRecordModel
        if record.page >= readModel.chapterList[record.chapter].pageCount - 1 {
            record.chapter += 1
            record.page = 0
        } else {
            record.page += 1
        }
        tempRecord = record
        return getReadViewController(record)
    }
}

extension RDPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let readModel = readModel, let record = readModel.record else {
            return nil
        }
        if record.page <= 0 && record.chapter <= 0 {
            return nil
        }
        tempNumber -= 1
        if abs(tempNumber) % 2 == 0 {
            let backgroundViewController = RDBackgroundViewController()
            backgroundViewController.targetView = getPreviewReadController()?.view
            return backgroundViewController
        }
        return getPreviewReadController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let readModel = readModel, let record = readModel.record else {
            return nil
        }
        if record.page >= readModel.chapterList[record.chapter].pageCount - 1 && record.chapter >= readModel.chapterList.count - 1 {
            return nil
        }
        tempNumber += 1
        if abs(tempNumber) % 2 == 0 {
            let backgroundViewController = RDBackgroundViewController()
            backgroundViewController.targetView = getReadViewController(record)?.view
            return backgroundViewController
        }
        return getNextReadController()
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let readModel = readModel, let record = tempRecord else {
            return
        }
        if completed {
            readModel.record = record
        }
    }
}
