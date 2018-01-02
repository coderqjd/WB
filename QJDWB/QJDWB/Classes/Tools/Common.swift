//
//  Common.swift
//  QJDWB
//
//  Created by 强进冬 on 2017/8/10.
//  Copyright © 2017年 强进冬. All rights reserved.
//

import UIKit

// MARK:- 授权的常量
let app_key      = "3508931377"
let app_secret   = "5f874393dca9c602abe9ed096af1f0b2"
let redirect_uri = "http://www.baidu.com"

// MARK:- 屏幕的宽高
let screenW = UIScreen.main.bounds.width
let screenH = UIScreen.main.bounds.height

// MARK:- picPicker通知常量
let picPickerAddPhotoNote    = "picPickerAddPhotoNote"
let picPickerRemovePhotoNote = "picPickerRemovePhotoNote"

// MARK:- showPhotoBrowser通知常量
let showPhotoBrowserNote        = "showPhotoBrowserNote"
let showPhotoBrowserIndexPath   = "showPhotoBrowserIndexPath"
let showPhotoBrowserPictureURLs = "showPhotoBrowserPictureURLs"

func qj_colorWith(r: CGFloat, g: CGFloat, b: CGFloat) -> UIColor {
    return UIColor.init(red: (r) / 255, green: (g) / 255, blue: (b) / 255, alpha: 1.0)
}

// MARK:- 自定义打印
func QJDLog<T>(file: String = #file, funcName: String = #function, lineNumber: Int = #line, _ message: T) {
    #if DEBUG
        let fileName = (file as NSString).lastPathComponent
        print("[\(fileName) \(funcName) \(lineNumber)]: \(message)")
    #endif
}
