//
//  AddCusAnnotation.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/11/23.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit
import MapKit

class CusAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String = ""
    var subtitle: String = ""
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}


class AddCusAnnotation: NSObject, MKMapViewDelegate {
    
    var mapDelegate: MKMapViewDelegate!
    var annotations: [MKAnnotation] = []
    var myMapView: MKMapView!
    
    //定义类方法
    class func shareInstance(mapView: MKMapView , delegate: MKMapViewDelegate) -> AddCusAnnotation{
        struct netSingle {
            static var predicate: dispatch_once_t = 0
            static var instance: AddCusAnnotation? = nil
        }
        //可以保证线程安全，保证只会被调用一次。
        dispatch_once(&netSingle.predicate,{
            netSingle.instance = AddCusAnnotation()
            netSingle.instance?.mapDelegate = delegate
            netSingle.instance?.myMapView = mapView
        })
        return netSingle.instance!
    }
    
    // 创建标注
    func createAnnotation(title: String, subTitle: String, coordinate: CLLocationCoordinate2D) {
        var annotation: CusAnnotation = self.createSingleAnnotation(title, subTitle: subTitle, coordinate: coordinate)
        myMapView.delegate = self
        myMapView.addAnnotation(annotation)
        self.annotations.append(annotation)
    }
    
    // 添加单个标注
    func addLocationAnnotation(title: String, subTitle: String, coordinate: CLLocationCoordinate2D) {
        myMapView.delegate = self
        myMapView.addAnnotation(self.createSingleAnnotation(title, subTitle: subTitle, coordinate: coordinate))
    }
    
    // 创建单个标注
    func createSingleAnnotation(title: String, subTitle: String, coordinate: CLLocationCoordinate2D) -> CusAnnotation {
        var annotation: CusAnnotation = CusAnnotation(coordinate: coordinate)
        annotation.title = title
        annotation.subtitle = subTitle
        
        return annotation
    }
    
    // 移除地图上的所有标注
    func removeAnnotation() {
        myMapView.removeAnnotations(annotations)
        annotations.removeAll(keepCapacity: true)
    }
}

