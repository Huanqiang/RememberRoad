//
//  ShowAddressBookTableView.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/11/23.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit

class ShowAddressBookTableView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var mainTableView: UITableView!
    var addressBookDic: NSDictionary = NSDictionary()
    var indexArray: NSArray = NSArray()
    var nameSortArr: NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addressBookDic = GainAddressBookClass.shareInstance().gainAddressBooks()
        self.indexArray = ChineseString.IndexArray(addressBookDic.allKeys)
        self.nameSortArr = ChineseString.LetterSortArray(addressBookDic.allKeys)
    }
    
    // MARK: - 设置右方表格的索引数组
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return indexArray;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return index
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var label: UILabel = UILabel(frame: CGRectMake(20, 0, 100, 30))
        label.font = UIFont(name: "Arial", size: 16)
        label.text = "   \(indexArray.objectAtIndex(section) as String)"
        return label
    }
    
    // MARK: - TableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return nameSortArr.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return nameSortArr.objectAtIndex(section).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier: String = "AddressBookCell"
        var cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as UITableViewCell
        
        let name: String = nameSortArr.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as String

        cell.textLabel.text = name
        cell.detailTextLabel?.text = addressBookDic.objectForKey(name) as? String
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)

        let name: String = nameSortArr.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as String
        self.createAlertView(name, phoneNumber: addressBookDic.objectForKey(name) as String)
    }
    
    func createAlertView(personName: String, phoneNumber: String) {
        var actionView:BOAlertController = BOAlertController(title: "提醒", message: "您确定要设置\(personName)为一键拨打的联系人吗？", subView: nil, viewController: self)
        
        let cancelItem: RIButtonItem = RIButtonItem.itemWithLabel("取消", action: {
            println(1)
        }) as RIButtonItem
        actionView.addButton(cancelItem, type: RIButtonItemType_Cancel)
        
        let okItem: RIButtonItem = RIButtonItem.itemWithLabel("确定", action: {
            LogInToolClass.shareInstance().saveInfo(phoneNumber, infoType: "phoneNumber")
            LogInToolClass.shareInstance().saveInfo(personName, infoType: "personName")
            self.goBackFunc()
        }) as RIButtonItem
        actionView.addButton(okItem, type: RIButtonItemType_Destructive)
        
        actionView.show()
    }
    
    // MARK: - 回跳
    @IBAction func goBack(sender: AnyObject) {
        self.goBackFunc()
    }
    
    func goBackFunc() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
