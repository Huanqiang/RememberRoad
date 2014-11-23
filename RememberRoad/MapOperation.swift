//
//  MapOperation.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/11/12.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit
import MapKit

class MapOperation: NSObject {
    
    //定义类方法
    class func shareInstance() -> MapOperation{
        struct netSingle{
            static var predicate: dispatch_once_t = 0
            static var instance: MapOperation? = nil
        }
        //可以保证线程安全，保证只会被调用一次。
        dispatch_once(&netSingle.predicate,{
            netSingle.instance = MapOperation()
        })
        return netSingle.instance!
    }
    
    // 设置地图的显示范围
    func setCoordinateRegion(map: MKMapView, center: CLLocationCoordinate2D) {
        //设置中心坐标
        // 创建一个以center为中心，上下各1000米，左右各1000米得区域，但其是一个矩形，不符合MapView的横纵比例
        let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(center, 250, 250)
        map.setRegion(viewRegion, animated: true)
    }
}
