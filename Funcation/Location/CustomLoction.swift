//
//  CustomLoction.swift
//  LoctionTest
//
//  Created by wanghuanqiang on 14/10/25.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit
import CoreLocation

class CustomLoction: NSObject {
    var clocation:CLLocationManager?
    
    //定义类方法
    class func shareInstance() -> CustomLoction{
        struct netSingle{
            static var predicate: dispatch_once_t = 0
            static var instance: CustomLoction? = nil
        }
        //可以保证线程安全，保证只会被调用一次。
        dispatch_once(&netSingle.predicate,{
            netSingle.instance = CustomLoction()
        })
        return netSingle.instance!
    }
    
    //创建 一个 CLLocationManager 类型的数据
    func initLocation(delegate: CLLocationManagerDelegate){
        clocation = CLLocationManager()
        clocation!.delegate = delegate
        clocation!.distanceFilter = 8.0
        clocation!.desiredAccuracy = kCLLocationAccuracyBest
        let sysVer:NSString = UIDevice.currentDevice().systemVersion
        if sysVer.floatValue >= 8.0 {
            clocation!.requestAlwaysAuthorization();
        }
    }
    
    //开始定位
    func startLocation() {
        clocation!.startUpdatingLocation();
    }
    
    //停止定位
    func stopLocation() {
        clocation!.stopUpdatingLocation();
    }
}

