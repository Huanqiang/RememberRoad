//
//  AdvertisementViewController.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/12/1.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit

class AdvertisementViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var mainTableView: UITableView!
    var appList: NSMutableArray = NSMutableArray()
    var refreshControl: UIRefreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //添加刷新
        
        self.refreshControl.frame.size.width = self.mainTableView.frame.width
        self.refreshControl.autoresizingMask = .FlexibleWidth
        refreshControl.addTarget(self, action: "refreshData", forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "松手刷新应用")
        mainTableView.addSubview(refreshControl)
    }
    
    // MARK: - TableView 操作
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellID: NSString = "AdvertisementCell"
        var cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellID) as UITableViewCell

        return cell;
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    // MARK: - 下拉操作
    func refreshData() {
        let randX:Int = Int(rand() % 3)
    }
}
