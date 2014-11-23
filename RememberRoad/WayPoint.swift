//
//  WayPoint.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/11/10.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import Foundation
import CoreData

@objc(WayPoint)
class WayPoint: NSManagedObject {

    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var state: NSNumber
    @NSManaged var time: NSDate
    @NSManaged var address: String

}
