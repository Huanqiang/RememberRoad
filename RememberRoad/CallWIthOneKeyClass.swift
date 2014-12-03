//
//  CallWIthOneKeyClass.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/11/25.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit

class CallWIthOneKeyClass: NSObject {
    
    var delegate:UIViewController!
    
    //定义类方法
    class func shareInstance(view:UIViewController) -> CallWIthOneKeyClass{
        struct netSingle{
            static var predicate: dispatch_once_t = 0
            static var instance: CallWIthOneKeyClass? = nil
        }
        //可以保证线程安全，保证只会被调用一次。
        dispatch_once(&netSingle.predicate,{
            netSingle.instance = CallWIthOneKeyClass()
            netSingle.instance?.delegate = view
        })
        return netSingle.instance!
    }
    
    func callWithOneKey() {
        let phoneNumber = LogInToolClass.shareInstance().getInfo("phoneNumber")
        let personName = LogInToolClass.shareInstance().getInfo("personName")
        if phoneNumber == "" {
            let showAddressBookTableView: ShowAddressBookTableView = self.delegate!.storyboard?.instantiateViewControllerWithIdentifier("ShowAddressBookTableView") as ShowAddressBookTableView
            self.delegate!.presentViewController(showAddressBookTableView, animated: true, completion: nil)
        }else {
            self.createAlertView(personName, phoneNumber: phoneNumber)
        }
    }
    
    // 弹出对话框 提醒用户拨打电话
    func createAlertView(personName: String, phoneNumber: String) {
        var actionView:BOAlertController = BOAlertController(title: "提醒", message: "您确定要拨打电话给\(personName)吗？", subView: nil, viewController: self.delegate!)
        
        let cancelItem: RIButtonItem = RIButtonItem.itemWithLabel("取消", action: {
            println(1)
        }) as RIButtonItem
        actionView.addButton(cancelItem, type: RIButtonItemType_Cancel)
        
        let okItem: RIButtonItem = RIButtonItem.itemWithLabel("确定", action: {
            let phone: NSString = "tel://\(phoneNumber)"
            phone.openURL()
        }) as RIButtonItem
        actionView.addButton(okItem, type: RIButtonItemType_Destructive)
        
        actionView.show()
    }

}
