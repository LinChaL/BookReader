//
//  RDReadConfigure.swift
//  BookReader
//
//  Created by linchl on 2018/6/22.
//  Copyright © 2018年 linchl. All rights reserved.
//

import Foundation
import UIKit

enum RDFontType: Int {
    case system     //系统
    case black      //黑体
    case regular    //楷体
    case song       //宋体
}

enum RDEffectType {
    case none           // 无效果
    case translation    // 平移
    case simulation     // 仿真
    case upAndDown      // 上下
}

let RDReadConfigureKey: String = "RDReadConfigureKey"


class RDReadConfigure: NSObject {
    
    // MAek: -- 属性
    
    /// 阅读文字颜色
    var textColor: UIColor = UIColor(0x919191)
    
    /// 字体类型
    var fontType: RDFontType = .system
    
    /// 字体大小
    var fontSize: CGFloat = 14
    
    /// 翻页效果
    var effectType: RDEffectType = .translation
    
    
    // MARK: -- 构造初始化
    
    /// 创建获取内存中的用户信息
    class func readInfo() ->RDReadConfigure {
        
        let info = UserDefaults.standard.object(forKey: RDReadConfigureKey)
        
        return RDReadConfigure(dict:info)
    }
    
    /// 初始化
    private init(dict:Any?) {
        
        super.init()
        
        setData(dict: dict)
    }
    
    /// 更新设置数据
    private func setData(dict:Any?) {
        
        if dict != nil {
            
            setValuesForKeys(dict as! [String : AnyObject])
        }
    }
    
    /// 获得颜色
    func readColor() ->UIColor {
        
//        return UIColor(patternImage:UIImage(named: "read_bg_0")!)
        return UIColor.rdBlack()
    }
    
    /// 获得文字Font
    private func readFont() -> UIFont {
        switch fontType {
        case .black:
            return UIFont(name: "EuphemiaUCAS-Italic", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        case .regular:
            return UIFont(name: "AmericanTypewriter-Light", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        case .song:
            return UIFont(name: "Papyrus", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)
        default:
            return UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    func readAttribute() -> [NSAttributedStringKey : Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10     // 行间距
        paragraphStyle.paragraphSpacing = 5 // 段间距
        paragraphStyle.lineHeightMultiple = 1.0 // 当前行间距的倍数
        paragraphStyle.alignment = .justified // 对齐
        
        return [NSAttributedStringKey.foregroundColor: textColor, NSAttributedStringKey.font: readFont(), NSAttributedStringKey.paragraphStyle: paragraphStyle]
    }
}
