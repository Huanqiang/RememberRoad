//
//  ViewController.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/10/28.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit

class ViewController: UIViewController, BMKMapViewDelegate {

    @IBOutlet weak var baiduMapView: BMKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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


}

