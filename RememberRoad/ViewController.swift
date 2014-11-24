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

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    @IBOutlet weak var callBtn: UIButton!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var mainMapView: MKMapView!
    var mapOperation: MapOperation = MapOperation.shareInstance()
    var location: CustomLoction? = CustomLoction.shareInstance()
    var addCusAnnotattion: AddCusAnnotation!
    var cusMapOverlay: CusMapOverlay!
    var cusCoreData: UserCoreDataManage = UserCoreDataManage()         //存储
    var wayPoint: UserWayPoint?
    var walkTimer: NSTimer = NSTimer()
    var routeLine: MKPolyline = MKPolyline()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cusMapOverlay = CusMapOverlay.shareInstance(self)
        addCusAnnotattion = AddCusAnnotation.shareInstance(self)
        
        // 创建 路况信息点
        wayPoint = UserWayPoint(time: NSDate())
        
        // 设置地图
        self.setCustonMap()
        
        // 创建 定位服务
        self.startLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - 地图服务
    func setCustonMap() {
        self.mainMapView.mapType = .Satellite
    }
    
    // 设置地图的显示范围
    func setCoordinateRegion(center: CLLocationCoordinate2D) {
        //设置中心坐标
        // 创建一个以center为中心，上下各1000米，左右各1000米得区域，但其是一个矩形，不符合MapView的横纵比例
        let viewRegion: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(center, 250, 250)
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
    
    
    // 获取 定位信息
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        var currLocation : CLLocation = locations.last as CLLocation
        let newLocation:CLLocation = currLocation.locationMarsFromEarth();
        
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
            }else{
                println("No Placemarks!")
            }
        });
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        println(error)
    }
    
    // MARK: - 开始外出走动
    @IBAction func startWalkingOut(sender: AnyObject) {
        self.addCusAnnotattion.removeAnnotation(mainMapView)
        self.cusMapOverlay.removeAllOverlay(mainMapView)
        self.wayPoint?.state = 0
        
        self.walkTimer = NSTimer.scheduledTimerWithTimeInterval(10, target: self, selector: "saveWayPointInfo", userInfo: nil, repeats: true)
        self.walkTimer.fire()
        
        self.createAlertView(NZAlertStyle.Info, title: "开始记路" , msg: "")
        self.locationImageView.hidden = false
    }
    
    func saveWayPointInfo() {
        self.wayPoint?.time = NSDate()
        self.cusCoreData.savePoint(self.wayPoint!)
    }
    

    // MARK: - 停止外出走动
    @IBAction func stopWalkingOut(sender: AnyObject) {
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
        }
    }
    
    // 数据解析
    func setPointInfo(wayPointArr: Array<UserWayPoint>) {
        let wayPointCount = wayPointArr.count;
        var coordinateArray: UnsafeMutablePointer<CLLocationCoordinate2D> = UnsafeMutablePointer.alloc(wayPointCount)
        for i in 0...(wayPointCount - 1) {
            coordinateArray[i] = CLLocationCoordinate2DMake(Double(wayPointArr[i].latitude), Double(wayPointArr[i].longitude))
        }

        self.addAnnotation("1", coordinate: coordinateArray[0])
        self.addAnnotation("2", coordinate: coordinateArray[wayPointCount - 1])
        
        cusMapOverlay.drawLineWithLocationArray(mainMapView, coordinateArray: coordinateArray, count: wayPointCount)
        free(coordinateArray);
        coordinateArray = nil;
    }
    
    // 添加标注
    func addAnnotation(subTitle: String,coordinate: CLLocationCoordinate2D) {
        addCusAnnotattion.createAnnotation(mainMapView, title: "标注", subTitle: subTitle, coordinate: coordinate)
    }

// MARK: - 此处有问题
    // 添加标注协议
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var annotationView: MKAnnotationView? = mapView.dequeueReusableAnnotationViewWithIdentifier("CustomAnnotation")
        
        annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "CustomAnnotation")
        annotationView?.canShowCallout = false
        annotationView?.enabled = false

        if (annotation.subtitle? != nil) {
            if annotation.subtitle == "1" {
                annotationView?.image = UIImage(named: "location_start.png")
            }else if annotation.subtitle == "2" {
                annotationView?.image = UIImage(named: "location_end.png")
            }
        }
        
        mapView.delegate = self
        return annotationView
    }
    
    // MARK: - 一键call
    @IBAction func callWithOneKey(sender: AnyObject) {
        let phoneNumber = LogInToolClass.shareInstance().getInfo("phoneNumber")
        let personName = LogInToolClass.shareInstance().getInfo("personName")
        if phoneNumber == "" {
            let showAddressBookTableView: ShowAddressBookTableView = self.storyboard?.instantiateViewControllerWithIdentifier("ShowAddressBookTableView") as ShowAddressBookTableView
            self.presentViewController(showAddressBookTableView, animated: true, completion: nil)
        }else {
            self.createAlertView(personName, phoneNumber: phoneNumber)
        }
    }
    
    // 弹出对话框 提醒用户拨打电话
    func createAlertView(personName: String, phoneNumber: String) {
        var actionView:BOAlertController = BOAlertController(title: "提醒", message: "您确定要拨打电话给\(personName)吗？", subView: nil, viewController: self)
        
        let cancelItem: RIButtonItem = RIButtonItem.itemWithLabel("取消", action: {
            println(1)
        }) as RIButtonItem
        actionView.addButton(cancelItem, type: RIButtonItemType_Cancel)
        
        let okItem: RIButtonItem = RIButtonItem.itemWithLabel("确定", action: {
            CusToolClass.shareInstance().openWebURL("tel://\(phoneNumber)")
        }) as RIButtonItem
        actionView.addButton(okItem, type: RIButtonItemType_Destructive)
        
        actionView.show()
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