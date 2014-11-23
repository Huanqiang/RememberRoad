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
    var coordinate:CLLocationCoordinate2D
    var title: String = ""
    var subtitle: String = ""
    
    init(coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}

class AddCusAnnotation: NSObject, MKMapViewDelegate {
    
    var mapDelegate: MKMapViewDelegate!
    var annotations: [MKAnnotation] = []
    
    //定义类方法
    class func shareInstance(delegate: MKMapViewDelegate) -> AddCusAnnotation{
        struct netSingle{
            static var predicate: dispatch_once_t = 0
            static var instance: AddCusAnnotation? = nil
        }
        //可以保证线程安全，保证只会被调用一次。
        dispatch_once(&netSingle.predicate,{
            netSingle.instance = AddCusAnnotation()
            netSingle.instance?.mapDelegate = delegate
        })
        return netSingle.instance!
    }
    
    func createAnnotation(myMapView: MKMapView, title: String, subTitle: String, coordinate: CLLocationCoordinate2D) {
        var annotation: CusAnnotation = CusAnnotation(coordinate: coordinate)
        annotation.title = title
        annotation.subtitle = subTitle
        myMapView.delegate = self
        myMapView.addAnnotation(annotation)
        self.annotations.append(annotation)
    }
    
    func removeAnnotation(myMapView: MKMapView) {
        myMapView.removeAnnotations(annotations)
        annotations.removeAll(keepCapacity: true)
    }

    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var annotationView: MKAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier("CustomAnnotation")
        
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
        annotationView?.canShowCallout = false
        annotationView?.enabled = false
        
        if annotation.subtitle == "1" {
            annotationView?.image = UIImage(named: "location_start.png")
        }else {
            annotationView?.image = UIImage(named: "location_end.png")
        }

        mapView.delegate = mapDelegate
        return annotationView
    }

}
