//
//  RDCoverController.swift
//  BookReader
//
//  Created by linchl on 2018/7/10.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation
import UIKit

protocol RDCoverControllerDelegate: class {
    
    func coverController(_ coverController: RDCoverController, currentController: UIViewController?, isFinish: Bool)
    
    // 获取当前控制器的前一页控制器
    func coverController(_ coverController: RDCoverController, getPreControllerWithCurrentController: UIViewController) -> UIViewController?
    
    // 获取当前控制器的下一页控制器
    func coverController(_ coverController: RDCoverController, getNextControllerWithCurrentController: UIViewController) -> UIViewController?
}

class RDCoverController: UIViewController {
    
    weak var delegate: RDCoverControllerDelegate?
    
    private var isLeft: Bool = true
    private var openAnimate: Bool = false
    private var isAnimateChange: Bool = false
    private var isPanBegin: Bool = false
    private var isPan: Bool = false
    
    private var moveSpace: CGFloat = 0
    private var preTouchPointX: CGFloat = -1
    private var startPointX: CGFloat = -1
    
    private(set) var currentViewController: UIViewController?
    private(set) var panViewController: UIViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    
    private func initialize() {
        self.openAnimate = true
        view.backgroundColor = .white
        let pan = UIPanGestureRecognizer(target: self, action: #selector(RDCoverController.touchPan(_:)))
        view.addGestureRecognizer(pan)
        view.layer.masksToBounds = true
    }
    
    private func getPanController(_ touchPoint: CGPoint) -> UIViewController? {
        guard let currentViewController = currentViewController else {
            return nil
        }
        var vc: UIViewController?
        if touchPoint.x > 0 { // 右滑显示上一页，获取的页面在左边
            isLeft = true
            vc = delegate?.coverController(self, getPreControllerWithCurrentController: currentViewController)
        } else {
            isLeft = false
            vc = delegate?.coverController(self, getNextControllerWithCurrentController: currentViewController)
        }
        if vc == nil {
            isAnimateChange = false
        }
        return vc
    }
    
    @objc private func touchPan(_ pan: UIPanGestureRecognizer) {
        let translatePoint = pan.translation(in: view)
        let touchPoint = pan.location(in: view)
        
        if preTouchPointX > 0 && (pan.state == .ended || pan.state == .changed) {
            moveSpace = touchPoint.x - preTouchPointX
        }
        preTouchPointX = touchPoint.x
        
        switch pan.state {
        case .began:
            guard !isAnimateChange else { return }
            isAnimateChange = true
            isPanBegin = true
            isPan = true
            startPointX = touchPoint.x
        case .changed:
            guard abs(translatePoint.x) > 0.01 else { return }
            if isPanBegin {
                isPanBegin = false
                panViewController = getPanController(translatePoint)
                if panViewController != nil {
                    addController(panViewController!)
                }
            }
            
            guard openAnimate, isPan else { return }
            
            if isLeft {
                panViewController?.view.frame = CGRect(x: translatePoint.x - ScreenWidth, y: 0, width: ScreenWidth, height: ScreenHeight)
            } else {
                currentViewController?.view.frame = CGRect(x: translatePoint.x, y: 0, width: ScreenWidth, height: ScreenHeight)
            }
        default:
            defer {
                preTouchPointX = -1
                moveSpace = 0
                isAnimateChange = false
            }
            
            guard isPan else {
                return
            }
            isPan = false
            if openAnimate {
                guard let panViewController = panViewController, let currentViewController = currentViewController else { return }
                var isSuccess: Bool = true
                if (isLeft && (panViewController.view.frame.origin.x < -0.8 * ScreenWidth || moveSpace < 0)) || (!isLeft && (currentViewController.view.frame.origin.x > 0.8 * ScreenWidth || moveSpace > 0)) {
                    isSuccess = false
                }
                gestureFinish(isSuccess: isSuccess)
            } else {
                gestureFinish(isSuccess: true, animated: false)
            }
        }
        
    }
    
    private func gestureFinish(isSuccess: Bool, animated: Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                if self.isLeft {
                    if isSuccess {
                        self.panViewController?.view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
                    } else {
                        self.panViewController?.view.frame = CGRect(x: -ScreenWidth, y: 0, width: ScreenWidth, height: ScreenHeight)
                    }
                } else {
                    if isSuccess {
                        self.currentViewController?.view.frame = CGRect(x: -ScreenWidth, y: 0, width: ScreenWidth, height: ScreenHeight)
                    } else {
                        self.currentViewController?.view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
                    }
                }
            }) { (_) in
                self.animateFinish(isSuccess)
            }
        } else {
            if isLeft {
                if isSuccess {
                    panViewController?.view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
                } else {
                    panViewController?.view.frame = CGRect(x: -ScreenWidth, y: 0, width: ScreenWidth, height: ScreenHeight)
                }
            } else {
                if isSuccess {
                    currentViewController?.view.frame = CGRect(x: -ScreenWidth, y: 0, width: ScreenWidth, height: ScreenHeight)
                } else {
                    currentViewController?.view.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
                }
            }
            self.animateFinish(isSuccess)
        }
    }
    
    private func addController(_ controller: UIViewController) {
        addChildViewController(controller)
        if isLeft {
            view.addSubview(controller.view)
            controller.view.frame = CGRect(x: -ScreenWidth, y: 0, width: ScreenWidth, height: ScreenHeight)
        } else {
            guard let currentViewController = currentViewController else {
                view.addSubview(controller.view)
                return
            }
            view.insertSubview(controller.view, belowSubview: currentViewController.view)
        }
        setControllerShadow(controller)
    }
    
    private func animateFinish(_ isSuccess: Bool) {
        if isSuccess {
            currentViewController?.view.removeFromSuperview()
            currentViewController?.removeFromParentViewController()
            currentViewController = panViewController
            delegate?.coverController(self, currentController: currentViewController, isFinish: isSuccess)
        } else {
            panViewController?.view.removeFromSuperview()
            panViewController?.removeFromParentViewController()
        }
        panViewController = nil
    }
    
    private func setControllerShadow(_ controller: UIViewController) {
        
    }
    
    func setController(_ controller: UIViewController?) {
        currentViewController = controller
        isLeft = false
        guard let controller = controller else { return }
        addController(controller)
    }
}
