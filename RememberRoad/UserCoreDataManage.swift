//
//  UserCoreDataManage.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/10/30.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import Foundation
import CoreData

class UserWayPoint {
    var longitude: NSNumber = 0.0
    var latitude: NSNumber = 0.0
    var state: NSNumber = 0.0
    var time: NSDate
    var address: NSString = ""
    
    init(time: NSDate) {
        self.time = time;
    }
    
    init(lo: NSNumber, la: NSNumber, sta: NSNumber, time: NSDate, address: NSString) {
        self.longitude = lo;
        self.latitude = la;
        self.state = sta;
        self.time = time;
        self.address = address;
    }
}

class UserCoreDataManage: NSObject {
//    var wayPoint: UserWayPoint?
    var context: NSManagedObjectContext?;
    
    override init() {
        if !(self.context != nil) {
            context = CoreDataOperation.shareInstance().initManagedObjectContext();
        }
    }
    
    //保存一个 wayPoint
    func savePoint(point: UserWayPoint) -> Bool {
        //取Entity对象
        var pointEntity = NSEntityDescription.insertNewObjectForEntityForName("WayPoint", inManagedObjectContext: self.context!) as WayPoint
        
        //对属性进行修改
        pointEntity.state = point.state
        pointEntity.longitude = point.longitude
        pointEntity.latitude = point.latitude
        pointEntity.time = point.time
        pointEntity.address = point.address
        
        let bool: Bool = CoreDataOperation.shareInstance().saveManagedObjectContext(self.context!);
        return bool;
    }

    //获取需要的所有的 wayPoint
    func searchPoints() -> Array<UserWayPoint> {
        var pointEntity = NSEntityDescription.entityForName("WayPoint", inManagedObjectContext: self.context!)
        var results: Array<UserWayPoint> = []
        
        //先获取 state = 1 的路况点，并按照时间顺序排
        let timeSort: NSSortDescriptor = NSSortDescriptor(key: "time", ascending: true)
        let sortDescriptors: Array = [timeSort]
        let timePre: NSPredicate = NSPredicate(format: "state = %d", 1)!
        let predicates: Array = [timePre]
        let searchResults = CoreDataOperation.shareInstance().selectData(self.context!, entity: pointEntity!, sortDescriptors: sortDescriptors, predicates: predicates)
        if (searchResults.isEmpty || searchResults.count == 0 || searchResults.count == 1) {
            return []
        }
        
        let lastStartPoint: WayPoint = searchResults[searchResults.count - 2] as WayPoint
        //获取时间大于 state=1 的所有点
        let timePre1: NSPredicate = NSPredicate(format: "time > %@", lastStartPoint.time)!
        let predicates1: Array = [timePre1]
        
        let searchResults1 = CoreDataOperation.shareInstance().selectData(self.context!, entity: pointEntity!, sortDescriptors: sortDescriptors, predicates: predicates1)
        if searchResults1.count == 0 || searchResults1.isEmpty {
            return [];
        }else {
            for obj: NSManagedObject in searchResults1 {
                let point: UserWayPoint = UserWayPoint(lo: obj.valueForKey("longitude")! as NSNumber, la: obj.valueForKey("latitude")! as NSNumber, sta: obj.valueForKey("state")! as NSNumber, time: obj.valueForKey("time")!  as NSDate, address: obj.valueForKey("address")! as NSString)
                results.append(point)
            }
            return results;
        }
    }
}
