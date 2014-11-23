//
//  LogInToolClass.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/11/23.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit

class LogInToolClass: NSObject {
    //定义类方法
    class func shareInstance() -> LogInToolClass{
        struct netSingle{
            static var predicate: dispatch_once_t = 0
            static var instance: LogInToolClass? = nil
        }
        //可以保证线程安全，保证只会被调用一次。
        dispatch_once(&netSingle.predicate,{
            netSingle.instance = LogInToolClass()
        })
        return netSingle.instance!
    }
    
    // MARK - 保存/获取/删除用户信息
    func saveInfo(info: String, infoType: String) {
        var settings: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        settings.removeObjectForKey(infoType)
        settings.setObject(info, forKey: infoType)
        settings.synchronize()
    }
    
    func getInfo(infoType: String) -> String {
        var settings: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        var userInfo: String? = settings.objectForKey(infoType) as? String
        if (userInfo != nil) {
            return userInfo!
        }else {
            return ""
        }
    }
    
    func removeInfo(infoType: String) {
        var setting: NSUserDefaults = NSUserDefaults.standardUserDefaults()
        setting.removeObjectForKey(infoType)
        setting.synchronize()
    }
    
    
    // MARK: - 判断是否登录
    
    func saveCookie(isLogin: Bool) {
        self.saveInfo(isLogin ? "1" : "0", infoType: "MyCookie")
    }
    
    func isCookie() -> Bool {
        let value: String? = self.getInfo("MyCookie")
        if value != nil && value == "1"{
            return true
        }else {
            return false
        }
    }
}
