//
//  CusToolClass.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/11/23.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit

class CusToolClass: NSObject {
    //定义类方法
    class func shareInstance() -> CusToolClass{
        struct netSingle{
            static var predicate: dispatch_once_t = 0
            static var instance: CusToolClass? = nil
        }
        //可以保证线程安全，保证只会被调用一次。
        dispatch_once(&netSingle.predicate,{
            netSingle.instance = CusToolClass()
        })
        return netSingle.instance!
    }

    // MARK: - 验证手机
    /**
    验证手机
     param: mobileNumber 需要验证的手机号码
     returns: 正确返回true ； 错误返回 false
    */
    func validateMobile(mobileNumber: String) -> Bool {
        let mobileStr = "^((145|147)|(15[^4])|(17[6-8])|((13|18)[0-9]))\\d{8}$"
        let cateMobileStr: NSPredicate = NSPredicate(format: "SELF MATCHES %@", mobileStr)!
        if cateMobileStr.evaluateWithObject(mobileNumber) == true {
            return true
        }else {
            return false
        }
    }
    // MARK: - 给我评分
    func gotoGrade(appleID: String) {
        let str: String = "itms-apps://itunes.apple.com/app/id\(appleID)"
        self.openWebURL(str)
    }
    
    // MARK: - 打开dream网址
    func openWebURL(urlString: String) {
        UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
    }
    
    
    
    
}
