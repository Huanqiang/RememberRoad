//
//  GuidePage.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/11/22.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit

class GuidePage: NSObject, SRFSurfboardDelegate {
    
    var delegate: SRFSurfboardDelegate!
    var delegateView: UIViewController!
    
    //定义类方法
    class func shareInstance(view: UIViewController, deleagte: SRFSurfboardDelegate) -> GuidePage{
        struct netSingle{
            static var predicate: dispatch_once_t = 0
            static var instance: GuidePage? = nil
        }
        //可以保证线程安全，保证只会被调用一次。
        dispatch_once(&netSingle.predicate,{
            netSingle.instance = GuidePage()
            netSingle.instance?.delegate = deleagte
            netSingle.instance?.delegateView = view
        })
        return netSingle.instance!
    }
    
    func GuideInterfaceOperation() {
        var str: String = LogInToolClass.shareInstance().getInfo("firstLogin")
        if str == "" || str.isEmpty {
            LogInToolClass.shareInstance().saveInfo("1", infoType: "firstLogin")
            self.createGuidePage()
        }
    }
    
    func createGuidePage() {
        var surfboard: SRFSurfboardViewController = self.delegateView.storyboard!.instantiateViewControllerWithIdentifier("SRFSurfboardViewController") as SRFSurfboardViewController
        let path:String = NSBundle.mainBundle().pathForResource("panels", ofType: "json")!
        let panels: NSArray = SRFSurfboardViewController.panelsFromConfigurationAtPath(path)
        surfboard.setPanels(panels)
        surfboard.delegate = self.delegate;
    }
    
    
}
