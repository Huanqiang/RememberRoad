//
//  CoreDataOperation.swift
//  CoreDataTutorial
//
//  Created by wanghuanqiang on 14/10/28.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import CoreData
import UIKit
import Foundation

class CoreDataOperation: NSObject {
    
    //定义类方法 -- 对外开发
    class func shareInstance() -> CoreDataOperation{
        struct netSingle{
            static var predicate:dispatch_once_t = 0
            static var instance:CoreDataOperation? = nil
        }
        //可以保证线程安全，保证只会被调用一次。
        dispatch_once(&netSingle.predicate,{
            netSingle.instance = CoreDataOperation()
        })
        return netSingle.instance!
    }
    
    //创建 NSManagedObjectContext 上下文
    func initManagedObjectContext() -> NSManagedObjectContext {
        var delegate: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate;
        return delegate.managedObjectContext!
    }
    
    //创建一个实体
    func initEntity(entityName: String, context: NSManagedObjectContext) -> NSEntityDescription{
        var entity: NSEntityDescription = NSEntityDescription.entityForName(entityName, inManagedObjectContext: context)!
        return entity;
    }
    
    //保存 ManagedObjectContext 实体
    func saveManagedObjectContext(context: NSManagedObjectContext) -> Bool {
        var errorInfo1:NSErrorPointer = nil
        
        if context.save(errorInfo1) {
            return true
        }else {
            return false
        }
    }
    
    
    //查询操作
    func selectData(context: NSManagedObjectContext, entity: NSEntityDescription, sortDescriptors: Array<NSSortDescriptor>, predicates: Array<NSPredicate> ) -> Array<NSManagedObject> {
        var fetchRequest: NSFetchRequest = NSFetchRequest()
        fetchRequest.entity = entity
        
        // 设置排序条件
        if !sortDescriptors.isEmpty || sortDescriptors.count != 0 {
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        // 设置查询条件
        if !predicates.isEmpty || predicates.count != 0 {
            for predicate: NSPredicate in predicates {
                fetchRequest.predicate = predicate
            }
        }
        
        var errorInfo:NSError?
        // 取结果集
        var resultArr = context.executeFetchRequest(fetchRequest, error: &errorInfo) as [NSManagedObject]
        
        return resultArr
    }
    
    //删除数据
    func deleteData(context: NSManagedObjectContext, deletedObj: NSManagedObject) ->Bool {
        //删除数据
        context.deleteObject(deletedObj)
        var bool: Bool = false
        
        if deletedObj.deleted {
            bool = self.saveManagedObjectContext(context)
        }
        return bool

    }
}
