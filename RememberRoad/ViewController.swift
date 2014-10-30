//
//  ViewController.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/10/28.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BMKMapViewDelegate, BMKLocationServiceDelegate {

    var baiduMapView: BMKMapView!
    var locationService: BMKLocationService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.setMap()
    }
    
    override func viewWillAppear(animated: Bool) {
        baiduMapView.viewWillAppear()
        baiduMapView.delegate = self
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        baiduMapView.viewWillDisappear()
        baiduMapView.delegate = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - 地图服务
    func setMap() {
        let frame: CGRect = UIScreen().bounds
        baiduMapView = BMKMapView(frame: frame)
        baiduMapView.delegate = self
        // 设置地图显示尺寸大小
        baiduMapView.zoomLevel = 3
        
        self.view = baiduMapView
    }
    
    // MARK: - 定位服务
    func setLocation() {
        self.locationService = BMKLocationService();
        self.locationService.delegate = self
    }
    
    func startLocation() {
        self.locationService.startUserLocationService()
        self.baiduMapView.showsUserLocation = true
    }
    
    func stopLocation() {
        self.locationService.stopUserLocationService()
    }
    
    func didUpdateUserLocation(userLocation: BMKUserLocation!) {
        self.baiduMapView.updateLocationData(userLocation)
    }
}

