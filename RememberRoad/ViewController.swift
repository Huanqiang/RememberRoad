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
    
    // AD
    var iAdSupported = false
    var iAdView:ADBannerView?
    var bannerView:GADBannerView?
    var statusbarHeight:CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cusMapOverlay = CusMapOverlay.shareInstance(self)
        addCusAnnotattion = AddCusAnnotation.shareInstance(self)
        callWithOneKey = CallWIthOneKeyClass.shareInstance(self)
        
        // 创建 路况信息点
        wayPoint = UserWayPoint(time: NSDate())
        
        // 设置地图
        self.setCustonMap()
        
        // 创建 定位服务
        self.startLocation()
        
        self.createAd()
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
                
                //添加标注
                self.addLoctionAnnotation(p.name, coordinate: newLocation.coordinate)
            }else{
                println("No Placemarks!")
            }
        });
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!){
        println(error)
    }
    
    func addLoctionAnnotation(title: String, coordinate: CLLocationCoordinate2D) {
        if (locationAnnotation != nil) {
            self.mainMapView.removeAnnotation(locationAnnotation)
        }
        locationAnnotation = CusAnnotation(coordinate: coordinate)
        locationAnnotation?.title = title
        locationAnnotation?.subtitle = "3"
        self.mainMapView.addAnnotation(locationAnnotation)
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
            }else if annotation.subtitle == "3" {
                annotationView?.image = UIImage(named: "LocationAnnotation.png")
                annotationView?.enabled = true
            }
        }
        
        mapView.delegate = self
        return annotationView
    }
    
    // MARK: - 切换地图类型
    @IBAction func switchMapType(sender: AnyObject) {
        var btn: UIButton = sender as UIButton
        if btn.tag == 1 {
            btn.tag = 2
            self.mainMapView.mapType = .Standard
            btn.setImage(UIImage(named: "Map_ChangedMapType1"), forState: .Normal)
        }else {
            btn.tag = 1
            self.mainMapView.mapType = .Satellite
            btn.setImage(UIImage(named: "Map_ChangedMapType2"), forState: .Normal)
        }
    }
    
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
    
    // MARK: - 广告
    
    // 创建广告
    func createAd() {
        iAdSupported = iAdTimeZoneSupported()
        
        if iAdSupported {
            iAdView = ADBannerView(adType: ADAdType.Banner)
            iAdView?.frame = CGRectMake(0, 0 - iAdView!.frame.height, iAdView!.frame.width, iAdView!.frame.height)
            statusbarHeight = self.view.frame.size.height - iAdView!.frame.height
            iAdView?.delegate = self
            self.view.addSubview(iAdView!)
            
        } else {
            bannerView = GADBannerView(adSize: kGADAdSizeBanner)
            bannerView?.adUnitID = "ca-app-pub-3724477525755491/7721017568"
            statusbarHeight = self.view.frame.size.height - bannerView!.frame.height
            bannerView?.frame.size.width = self.view.frame.size.width
            bannerView?.delegate = self
            bannerView?.rootViewController = self
            self.view.addSubview(bannerView!)
            bannerView?.loadRequest(GADRequest())
        }

    }
    
    // 重画框架
    func relayoutViews() {
        var bannerFrame = iAdSupported ? iAdView!.frame : bannerView!.frame
        bannerFrame.origin.x = 0
        bannerFrame.origin.y = statusbarHeight
        if iAdSupported {
            iAdView!.frame = bannerFrame
        } else {
            bannerView!.frame = bannerFrame
        }
        
        self.mainMapView.frame.size.height = self.view.frame.size.height - bannerFrame.size.height
        self.settingBtn.frame.size.height = self.view.frame.size.height - bannerFrame.size.height
    }
    
    // MARK: - iAd
    
    // iAd func 判断该地区支不支持 iAd
    func iAdTimeZoneSupported()->Bool {
        let iAdTimeZones = "America/;US/;Pacific/;Asia/Tokyo;Europe/".componentsSeparatedByString(";")
        var myTimeZone = NSTimeZone.localTimeZone().name
        for zone in iAdTimeZones {
            if (myTimeZone.hasPrefix(zone)) {
                return true;
            }
        }
        
        return false;
    }

    // iAdBannerViewDelegate
    func bannerViewWillLoadAd(banner: ADBannerView!) {
        println("bannerViewWillLoadAd")
    }
    
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        println("bannerViewDidLoadAd")
        relayoutViews()
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        println("didFailToReceiveAd error:\(error)")
        relayoutViews()
    }
    
    func bannerViewActionDidFinish(banner: ADBannerView!) {
        println("bannerViewActionDidFinish")
        relayoutViews()
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        println("bannerViewActionShouldBegin")
        return true;
    }

    // MARK: - GADBannerView
    
    // GADBannerViewDelegate
    func adViewDidReceiveAd(view: GADBannerView!) {
        println("adViewDidReceiveAd:\(view)");
        relayoutViews()
    }
    
    func adView(view: GADBannerView!, didFailToReceiveAdWithError error: GADRequestError!) {
        println("\(view) error:\(error)")
        relayoutViews()
    }
    
    func adViewWillPresentScreen(adView: GADBannerView!) {
        println("adViewWillPresentScreen:\(adView)")
        relayoutViews()
    }
    
    func adViewWillLeaveApplication(adView: GADBannerView!) {
        println("adViewWillLeaveApplication:\(adView)")
        relayoutViews()
    }
    
    func adViewWillDismissScreen(adView: GADBannerView!) {
        println("adViewWillDismissScreen:\(adView)")
        relayoutViews()
    }
}