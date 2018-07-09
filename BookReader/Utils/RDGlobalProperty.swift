//
//  RDGlobalProperty.swift
//  BookReader
//
//  Created by linchl on 2018/6/22.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation
import UIKit

// MARK: -- 屏幕属性

/// 屏幕宽度
let ScreenWidth: CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高度
let ScreenHeight: CGFloat = UIScreen.main.bounds.size.height

/// iPhone X
let isIphoneX: Bool = (ScreenHeight == CGFloat(812) && ScreenWidth == CGFloat(375))

/// 导航栏高度
let NavgationBarHeight: CGFloat = isIphoneX ? 88 : 64

/// TabBar高度
let TabBarHeight: CGFloat = 49

/// StatusBar高度
let StatusBarHeight: CGFloat = isIphoneX ? 44 : 20

let bottomHeight: CGFloat = isIphoneX ? 34 : 0

// MARK: -- 阅读页属性

let RDLeftSpace: CGFloat = 15
let RDTopSpace: CGFloat = 10

var readTableViewFrame = CGRect(x: RDLeftSpace, y: StatusBarHeight + RDTopSpace, width: ScreenWidth - 2 * RDLeftSpace, height: ScreenHeight - StatusBarHeight - 2 * RDTopSpace - bottomHeight)

var readViewFrame = CGRect(origin: .zero, size: readTableViewFrame.size)
