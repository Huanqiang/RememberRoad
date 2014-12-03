//
//  ExtensionWithNSSting.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/12/2.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit

extension NSString {
    /**
    判断手机号码是否符合正则表达式的要求
    
    :returns: 符合返回 ture，不符合返回 false
    */
    func validateMobile() -> Bool {
        let mobileStr = "^((145|147)|(15[^4])|(17[6-8])|((13|18)[0-9]))\\d{8}$"
        let cateMobileStr: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileStr)!
        if cateMobileStr.evaluateWithObject(self) == true {
            return true
        }else {
            return false
        }
    }
    
    /**
    转到商店进行评分
    */
    func gotoGrade() {
        let str = NSString(string: "itms-apps://itunes.apple.com/app/id\(self)")
        self.openURL()
    }
    
    /**
    在浏览器中打开链接
    */
    func openURL() {
        UIApplication.sharedApplication().openURL(NSURL(string: self)!)
    }
    
}
