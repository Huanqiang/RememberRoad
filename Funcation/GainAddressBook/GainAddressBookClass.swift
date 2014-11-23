//
//  GainAddressBookClass.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/11/23.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit
import Foundation
import AddressBook
import AddressBookUI

class GainAddressBookClass: NSObject {
    
    //定义类方法
    class func shareInstance() -> GainAddressBookClass{
        struct netSingle{
            static var predicate: dispatch_once_t = 0
            static var instance: GainAddressBookClass? = nil
        }
        //可以保证线程安全，保证只会被调用一次。
        dispatch_once(&netSingle.predicate,{
            netSingle.instance = GainAddressBookClass()
        })
        return netSingle.instance!
    }
    
    func gainAddressBooks() -> NSDictionary {
        var error:Unmanaged<CFError>?
        var addressBook: ABAddressBookRef? = ABAddressBookCreateWithOptions(nil, &error).takeRetainedValue()
        
        let sysAddressBookStatus = ABAddressBookGetAuthorizationStatus()
        
        if sysAddressBookStatus == .Denied || sysAddressBookStatus == .NotDetermined {
            // Need to ask for authorization
            var authorizedSingal:dispatch_semaphore_t = dispatch_semaphore_create(0)
            var askAuthorization:ABAddressBookRequestAccessCompletionHandler = { success, error in
                if success {
                    ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray
                    dispatch_semaphore_signal(authorizedSingal)
                }
            }
            ABAddressBookRequestAccessWithCompletion(addressBook, askAuthorization)
            dispatch_semaphore_wait(authorizedSingal, DISPATCH_TIME_FOREVER)
        }
        
        return analyzeAddressBooks( ABAddressBookCopyArrayOfAllPeople(addressBook).takeRetainedValue() as NSArray )
    }
    
    //获取 只有姓名和第一个号码的 通讯录列表
    func analyzeAddressBooks(sysContacts:NSArray) -> NSDictionary  {
        var allName: NSMutableArray = NSMutableArray()
        var allPhoneNumber: NSMutableArray = NSMutableArray()
        for contact in sysContacts {
            // 姓
            let firstName: String = ABRecordCopyValue(contact, kABPersonFirstNameProperty)?.takeRetainedValue() as String? ?? ""
            // 名
            let lastName: String = ABRecordCopyValue(contact, kABPersonLastNameProperty)?.takeRetainedValue() as String? ?? ""
            var completeName: NSString = "\(lastName)\(firstName)"
            if completeName != "" {
                // 去除名字中的空格
                completeName = completeName.stringByReplacingOccurrencesOfString(" ", withString: "")
                allName.addObject(completeName)
                
                // 读取电话多值
                let phone: ABMultiValueRef = ABRecordCopyValue(contact, kABPersonPhoneProperty)?.takeRetainedValue() as ABMultiValueRef? ?? ""
                var phoneNumber:NSString = ABMultiValueCopyValueAtIndex(phone, 0)?.takeRetainedValue() as NSString
                // 去除电话号码中的 "-"符号
                phoneNumber = phoneNumber.stringByReplacingOccurrencesOfString("-", withString: "")
                
                allPhoneNumber.addObject(phoneNumber)
            }
        }
        return NSDictionary(objects: allPhoneNumber, forKeys: allName)
    }
    
    // 获取较为完整的通讯录列表
    func analyzeCompleteSysContacts(sysContacts:NSArray) -> [[String:String]] {
        var allContacts:Array = [[String:String]]()
        for contact in sysContacts {
            var currentContact:Dictionary = [String:String]()
            // 姓
            currentContact["FirstName"] = ABRecordCopyValue(contact, kABPersonFirstNameProperty)?.takeRetainedValue() as String? ?? ""
            // 名
            currentContact["LastName"] = ABRecordCopyValue(contact, kABPersonLastNameProperty)?.takeRetainedValue() as String? ?? ""
            // 昵称
            currentContact["Nikename"] = ABRecordCopyValue(contact, kABPersonNicknameProperty)?.takeRetainedValue() as String? ?? ""
            // 公司（组织）
            currentContact["Organization"] = ABRecordCopyValue(contact, kABPersonOrganizationProperty)?.takeRetainedValue() as String? ?? ""
            // 职位
            currentContact["JobTitle"] = ABRecordCopyValue(contact, kABPersonJobTitleProperty)?.takeRetainedValue() as String? ?? ""
            // 部门
            currentContact["Department"] = ABRecordCopyValue(contact, kABPersonDepartmentProperty)?.takeRetainedValue() as String? ?? ""

            //读取电话多值
            let phone: ABMultiValueRef = ABRecordCopyValue(contact, kABPersonPhoneProperty)?.takeRetainedValue() as ABMultiValueRef? ?? ""
            currentContact["PhoneNumber"] = ABMultiValueCopyValueAtIndex(phone, 0)?.takeRetainedValue() as? String
            
            //备注
            currentContact["Note"] = ABRecordCopyValue(contact, kABPersonNoteProperty)?.takeRetainedValue() as String? ?? ""
            allContacts.append(currentContact)
        }
        return allContacts
    }
}
