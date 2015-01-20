//
//  CalculationDistanceClass.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 15/1/20.
//  Copyright (c) 2015年 王焕强. All rights reserved.
//

import UIKit
import MapKit

class CalculationDistanceClass: NSObject {
    
    var locations: [CLLocation]!
    
    //定义类方法
    class func shareInstance(aLocations: [CLLocation]) -> CalculationDistanceClass{
        struct netSingle {
            static var predicate: dispatch_once_t = 0
            static var instance: CalculationDistanceClass? = nil
        }
        //可以保证线程安全，保证只会被调用一次。
        dispatch_once(&netSingle.predicate,{
            netSingle.instance = CalculationDistanceClass(aLocations: aLocations)
        })
        return netSingle.instance!
    }
    
    override init() {}
    
    init(aLocations: [CLLocation]) {
        self.locations = aLocations
    }
    
    // 计算一组长度
    func calulationDistance() -> CGFloat {
        var distance: CGFloat = 0.0
        
        for var i = 0; i < locations.count - 1; i++ {
            distance += self.calulationDistanceWithTwoPoint(locations[i], secondPoint: locations[i + 1])
        }
        
        return distance;
    }
    
    func calulationDistanceWithTwoPoint(firstPoint: CLLocation, secondPoint: CLLocation) -> CGFloat {
        return CGFloat(firstPoint.distanceFromLocation(secondPoint));
    }

    
    // 根据经纬度获取 CLLocation
    func gainCLLocationWithCoordinate(longitude: Double,latitude: Double) -> CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
}
