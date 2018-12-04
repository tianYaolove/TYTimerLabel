//
//  TYCommonPublic.swift
//  countDown
//
//  Created by 李田 on 2018/11/28.
//  Copyright © 2018年 tianyao. All rights reserved.
//

import UIKit

/// 屏幕宽度
let screenW = UIScreen.main.bounds.size.width
/// 屏幕高度
let screenH = UIScreen.main.bounds.size.height
/// iPhone4
let isIphone4 = screenH  < 568 ? true : false
/// iPhone 5
let isIphone5 = screenH  == 568 ? true : false
/// iPhone 6
let isIphone6 = screenH  == 667 ? true : false
/// iphone 6P
let isIphone6P = screenH == 736 ? true : false
/// iphone X
let isIphoneX = screenH == 812 ? true : false
/// navigationBarHeight
let kNavBarH : CGFloat = isIphoneX ? 88 : 64
/// tabBarHeight
let kTarBarH : CGFloat = isIphoneX ? 49 + 34 : 49
/// statusHeight(状态栏高度)
let kStatusH: CGFloat = isIphoneX ? 44 : 20


/// 宽度适配(已经 * 0.5)
func kScreenPortionW(w: CGFloat) -> CGFloat {
    return w * screenW / 375 * 0.5
}
/// 高度适配(已经 * 0.5)
func kScreenPortionH(h: CGFloat) -> CGFloat {
    return isIphoneX ? h * 736 / 667 * 0.5 : h * screenH / 667 * 0.5
}

func fontSizeXP(fontS: CGFloat) -> UIFont {
    var font = UIFont()
    let fontSize = isIphoneX ? fontS*736 / 667.0 * 0.5 : fontS*screenH / 667.0 * 0.5
    font = UIFont.systemFont(ofSize: fontSize)
    return font
}

// 加粗字体
func boldFontSizeXP(fontS: CGFloat) -> UIFont {
    var font = UIFont()
    let fontSize = isIphoneX ? fontS*736 / 667.0 * 0.5 : fontS*screenH / 667.0 * 0.5
    font = UIFont.boldSystemFont(ofSize: fontSize)
    return font
}
