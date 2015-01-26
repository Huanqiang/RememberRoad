//
//  CusMapOverlay.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/11/13.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import MapKit
import CoreLocation

class CusMapOverlay: NSObject, MKMapViewDelegate {
    
    var routeLine: MKPolyline = MKPolyline()
    var delegate: MKMapViewDelegate!
    
    //定义类方法
    class func shareInstance(delegate: MKMapViewDelegate) -> CusMapOverlay{
        struct netSingle{
            static var predicate: dispatch_once_t = 0
            static var instance: CusMapOverlay? = nil
        }
        //可以保证线程安全，保证只会被调用一次。
        dispatch_once(&netSingle.predicate,{
            netSingle.instance = CusMapOverlay()
            netSingle.instance?.delegate = delegate
        })
        return netSingle.instance!
    }
    
    // MARK: - 删除连线
    func removeAllOverlay(map: MKMapView) {
        map.removeOverlay(self.routeLine)
    }
    
    // MARK: - 新增连线
       
    // 绘制连线
    func drawLineWithLocationArray(map: MKMapView, coordinateArray: UnsafeMutablePointer<CLLocationCoordinate2D>, count: Int) {
        self.routeLine = MKPolyline(coordinates: coordinateArray, count: count);
        map.delegate = self
        map.setVisibleMapRect(self.routeLine.boundingMapRect, animated: true)
        map.addOverlay(self.routeLine)
    }
    
    // 添加线段 回调函数
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        mapView.delegate = self.delegate
        if(overlay.isEqual(self.routeLine)) {
            var routeLineView = MKPolylineRenderer(overlay: overlay)
            routeLineView.fillColor = UIColor.redColor()
            routeLineView.strokeColor = UIColor.redColor()
            routeLineView.lineWidth = 3
            routeLineView.alpha = 0.6
            return routeLineView
        }
        return nil
    }
}
