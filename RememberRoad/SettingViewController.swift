//
//  SettingViewController.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/12/1.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let appId: NSString = "123456789"
    
    @IBOutlet weak var mainTableView: UITableView!
    let tableViewData: NSArray = [["设置联系人"],["一键评分", "推荐应用", "关于“户外记路”"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Come Back

    @IBAction func comeback(sender: AnyObject) {
        self.goBackFunc()
    }
    
    func goBackFunc() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableViewData.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewData.objectAtIndex(section).count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell", forIndexPath: indexPath) as UITableViewCell

        cell.textLabel.text = tableViewData.objectAtIndex(indexPath.section).objectAtIndex(indexPath.row) as NSString

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if indexPath.section == 0 {
            self.selectFunctionWithSection1(indexPath.row)
        }else if indexPath.section == 1 {
            self.selectFunctionWithSection2(indexPath.row)
        }
        
    }
    
    func selectFunctionWithSection1(row: Int) {
        if row == 0 {
            self.gainToShowAddressBookTableView()
        }
    }
    
    func selectFunctionWithSection2(row: Int) {
        if row == 0 {
            // 商店评分
            appId.gotoGrade()
        }else if row == 1 {
            self.recommendApp()
        }else if row == 2 {
            self.gainToAboutUs()
        }
    }
    
    // 设置联系人
    func gainToShowAddressBookTableView() {
        let showAddressBook:ShowAddressBookTableView = self.storyboard?.instantiateViewControllerWithIdentifier("ShowAddressBookTableView") as ShowAddressBookTableView
        self.presentViewController(showAddressBook, animated: true, completion: nil)
    }
    
    // 推荐应用
    func recommendApp() {
        
    }
    
    // 关于我们
    func gainToAboutUs() {
        
    }
}
