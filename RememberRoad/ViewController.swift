//
//  ViewController.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/10/28.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import iAd

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, ADBannerViewDelegate, GADBannerViewDelegate{
    
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var mainMapView: MKMapView!
    @IBOutlet weak var distanceBGView: UIView!
    @IBOutlet weak var distanceLabel: UILabel!
    
    
    var mapOperation: MapOperation = MapOperation.shareInstance()
    var location: CustomLoction? = CustomLoction.shareInstance()
    var addCusAnnotattion: AddCusAnnotation!
    var cusMapOverlay: CusMapOverlay!
    var callWithOneKey: CallWIthOneKeyClass!
    var cusCoreData: UserCoreDataManage = UserCoreDataManage()         //存储
    var wayPoint: UserWayPoint?
    var walkTimer: NSTimer = NSTimer()
    var routeLine: MKPolyline = MKPolyline()
    var locationAnnotation: CusAnnotation?
    var isNeedLocationAnnotation:Bool = true                      // NO:表示不需要添加定位标注，YES：表示需要
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cusMapOverlay = CusMapOverlay.shareInstance(self)
        addCusAnnotattion = AddCusAnnotation.shareInstance(self.mainMapView , delegate: self)
        callWithOneKey = CallWIthOneKeyClass.shareInstance(self)
        
        // 设置记路距离背景 View 的圆角
        self.distanceBGView.layer.masksToBounds = true
        self.distanceBGView.layer.cornerRadius = 8.0
        
        // 创建 路况信息点
        wayPoint = UserWayPoint(time: NSDate())
        
        // 设置地图
        self.setCustonMap()
        
        // 创建 定位服务
        self.startLocation()
        self.detectionNetState()
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    // MARK: - 判断 APP 所处的网络状态以提醒用户
    func detectionNetState() {
        let state:NSString = DetectionNetworkStatus.checkUpNetworkStatus()
        var msg: NSString = "";
        switch state {
            case "0" : msg = "请您打开手机流量，否则只能显示您的大概位置，不能显示定位"
            case "1" : msg = ""
            case "2" : msg = "您正处于 WIFI 网络，不能准确定位，请使用手机流量"
            default : msg = ""
        }
        
        if !msg.isEqualToString("") {
            NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: Selector("createAlertView:"), userInfo: msg, repeats: false)
        }
    }
    
    func createAlertView(timer: NSTimer) {
        let msg:String = timer.userInfo as String
        var alert:BOAlertController = BOAlertController(title: "抱歉", message: msg, subView: nil, viewController: self);
        let okItem:RIButtonItem = RIButtonItem.itemWithLabel("好的", action: {
            println("1")
        }) as RIButtonItem
        alert.addButton(okItem, type:RIButtonItemType_Other)
        alert.show()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - 地图服务
    func setCustonMap() {
        self.mainMapView.mapType = .Standard
    }
    
    // 设置地图的显示范围
    func setCoordinateRegion(center: CLLocationCoordinate2D) {
        // 创建一个以center为中心，上下各1000米，左右各1000米得区域，但其是一个矩形，不符合MapView的横纵比例
        let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(center, 500, 500)
        mainMapView.setRegion(viewRegion, animated: true)
    }
    
    // MARK: - 定位服务
    func startLocation() {
        location!.initLocation(self)
        location!.startLocation()
        mainMapView!.showsUserLocation = true
    }
    
    func stopLocation() {
        location?.stopLocation()
    }
    
    // MARK: - 地图定位服务
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!) {
        let currLocation : CLLocation = userLocation.location as CLLocation
//        mapView.
        
        var newLocation:CLLocation = currLocation.locationMarsFromEarth()
        if self.isLocationInOfChina(currLocation.coordinate) {
            newLocation = currLocation
        }
        
        self.setCoordinateRegion(newLocation.coordinate)
        self.wayPoint?.latitude = newLocation.coordinate.latitude;
        self.wayPoint?.longitude = newLocation.coordinate.longitude;
        
        let geo: CLGeocoder = CLGeocoder();
        geo.reverseGeocodeLocation(newLocation, completionHandler: {
            placeMarks, error in
            if error != nil {
                //可进行错误操作
                println(error)
                return
            }
            
            let places = placeMarks as [CLPlacemark]
            if places.count > 0 {
                var p:CLPlacemark = places[0] as CLPlacemark
                self.wayPoint?.address = p.name
                
                //添加标注
                if self.isNeedLocationAnnotation {
                    self.addLoctionAnnotation(p.name, coordinate: newLocation.coordinate)
                }
                
            }else{
                println("No Placemarks!")
            }
        });
    }
    
    //判断是不是在中国
    func isLocationInOfChina(location: CLLocationCoordinate2D) -> Bool {
        if (location.longitude < 72.004 || location.longitude > 137.8347 || location.latitude < 0.8293 || location.latitude > 55.8271) {
            return false;
        }
        return true;

    }
    
    // MARK: - 新增标注
    func addLoctionAnnotation(title: String, coordinate: CLLocationCoordinate2D) {
        if (locationAnnotation != nil) {
            self.mainMapView.removeAnnotation(locationAnnotation)
        }
        locationAnnotation = CusAnnotation(coordinate: coordinate)
        locationAnnotation?.title = "3"
        locationAnnotation?.subtitle = title
        self.mainMapView.addAnnotation(locationAnnotation)
    }
    
    // MARK: - 开始外出走动
    @IBAction func startWalkingOut(sender: AnyObject) {
        if locationAnnotation != nil {
            self.isNeedLocationAnnotation = true
        }
        
        self.addCusAnnotattion.removeAnnotation()
        self.cusMapOverlay.removeAllOverlay(mainMapView)
        self.wayPoint?.state = 0
        
        self.walkTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "saveWayPointInfo", userInfo: nil, repeats: true)
        self.walkTimer.fire()
        
        
        self.locationImageView.hidden = false
        self.distanceBGView.hidden = true
        self.distanceLabel.hidden = true
        self.createAlertView(NZAlertStyle.Info, title: "开始记路" , msg: "")
    }
    
    func saveWayPointInfo() {
        self.wayPoint?.time = NSDate()
        self.cusCoreData.savePoint(self.wayPoint!)
    }
    

    // MARK: - 停止外出走动
    @IBAction func stopWalkingOut(sender: AnyObject) {
        // 去除定位标注
        if locationAnnotation != nil {
            self.isNeedLocationAnnotation = false
            self.mainMapView.removeAnnotation(locationAnnotation)
        }
        
        self.createAlertView(NZAlertStyle.Success, title: "结束记路", msg: "")
        
        self.locationImageView.hidden = true
        self.walkTimer.invalidate()
        
        //保存最后一个路线点
        self.wayPoint?.state = 1
        self.saveWayPointInfo()
        
        //获取路线点
        let wayPointArr: [UserWayPoint] = self.cusCoreData.searchPoints()
        if !wayPointArr.isEmpty && wayPointArr.count != 1 {
            self.setPointInfo(wayPointArr)
            self.showUserDistance(wayPointArr)     // 设置用户走了多少米
        }
    }
    
    // 数据解析
    func setPointInfo(wayPointArr: Array<UserWayPoint>) {
        let wayPointCount = wayPointArr.count;
        var coordinateArray: UnsafeMutablePointer<CLLocationCoordinate2D> = UnsafeMutablePointer.alloc(wayPointCount)
        for i in 0...(wayPointCount - 1) {
            coordinateArray[i] = CLLocationCoordinate2DMake(Double(wayPointArr[i].latitude), Double(wayPointArr[i].longitude))
        }
        
        
        self.addAnnotation("此次行程的起点：", subTitle: wayPointArr[0].address, coordinate: coordinateArray[0])
        self.addAnnotation("此次行程的终点：", subTitle: wayPointArr[wayPointCount - 1].address, coordinate: coordinateArray[wayPointCount - 1])
        
        cusMapOverlay.drawLineWithLocationArray(mainMapView, coordinateArray: coordinateArray, count: wayPointCount)
        free(coordinateArray);
        coordinateArray = nil;
    }
    
    // 添加开始/结束标注
    func addAnnotation(title: String, subTitle: String, coordinate: CLLocationCoordinate2D) {
        addCusAnnotattion.createAnnotation(title, subTitle: subTitle, coordinate: coordinate)
    }
    
    
    // 计算用户行走距离
    func showUserDistance(wayPointArr: [UserWayPoint]) {
        distanceBGView.hidden = false
        distanceLabel.hidden = false
        distanceLabel.text = NSString(format: "您已经走了 %.1f 米", Float(self.calculationDistance(wayPointArr)))
    }
    
    func calculationDistance(wayPointArr: [UserWayPoint]) -> CGFloat {
        let calculationDis = CalculationDistanceClass()
        
        var locations: [CLLocation] = []
        for i in 0...(wayPointArr.count - 1) {
            locations.append(calculationDis.gainCLLocationWithCoordinate(Double(wayPointArr[i].latitude), latitude: Double(wayPointArr[i].longitude)))
        }
        
        calculationDis.locations = locations
        return calculationDis.calulationDistance()
    }

// MARK: - 此处有问题
    // 添加标注协议
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var annotationView: MKAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier("CustomAnnotation")
        
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
        annotationView?.canShowCallout = true
        annotationView?.enabled = true

        if (annotation.title? != nil) {
            if annotation.title == "此次行程的起点：" {
                annotationView?.image = UIImage(named: "location_start.png")
            }else if annotation.title == "此次行程的终点：" {
                annotationView?.image = UIImage(named: "location_end.png")
            }else if annotation.title == "3" {
                annotationView?.image = UIImage(named: "LocationAnnotation.png")
                annotationView?.canShowCallout = false
                annotationView?.enabled = false
            }
        }
        
        mapView.delegate = self
        return annotationView
    }
    
    // MARK: - 选中大头针时触发
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
    }
    
    // MARK: - 取消选中时触发
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        
    }
    
    

    
    // MARK: - 切换地图类型
    @IBAction func switchMapType(sender: AnyObject) {
        var btn: UIButton = sender as UIButton
        if btn.tag == 1 {
            btn.tag = 2
            self.mainMapView.mapType = .Satellite
            btn.setImage(UIImage(named: "Map_ChangedMapType2"), forState: .Normal)
        }else {
            btn.tag = 1
            self.mainMapView.mapType = .Standard
            btn.setImage(UIImage(named: "Map_ChangedMapType1"), forState: .Normal)
        }
    }

// MARK: - 其他
    // MARK: - 一键call
    @IBAction func callWithOneKey(sender: AnyObject) {
        callWithOneKey.callWithOneKey()
    }

    // MARK: - 弹出框
    //NZAlertViewDelegate
    func willPresentNZAlertView(alertView: NZAlertView!) {
        println("\t willPresentNZAlertView")
    }
    
    func didPresentNZAlertView(alertView: NZAlertView!) {
        println("\t didPresentNZAlertView")
    }
    
    func NZAlertViewDidDismiss(alertView: NZAlertView!) {
        println("\t NZAlertViewDidDismiss")
    }
    
    func NZAlertViewWillDismiss(alertView: NZAlertView!) {
        println("\t NZAlertViewWillDismiss")
    }
    
    func createAlertView(style: NZAlertStyle,title: String, msg: String) {
        var alert: NZAlertView = NZAlertView(style: style, title: title, message: msg, delegate: self)
        alert.show();
    }
    
}