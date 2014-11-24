//
//  GuidePage.swift
//  RememberRoad
//
//  Created by wanghuanqiang on 14/11/22.
//  Copyright (c) 2014年 王焕强. All rights reserved.
//

import UIKit

class GuidePageViewController: UIViewController, MYIntroductionDelegate {
    var delegateView: UIViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(animated)
//        self.GuideInterfaceOperation()
//    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.GuideInterfaceOperation()
    }
    
    func GuideInterfaceOperation() {
        var str: String = LogInToolClass.shareInstance().getInfo("firstLogin")
        if str == "1" {
            self.gotoMainViewController()
        }else {
            LogInToolClass.shareInstance().saveInfo("1", infoType: "firstLogin")
            self.createGuidePage()
        }
    }
    
    func createGuidePage() {
        var introductionView:MYBlurIntroductionView = MYBlurIntroductionView(frame: CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height))
        introductionView.delegate = self
        introductionView.BackgroundImageView.image = UIImage(named: "Toronto, ON.jpg")
        introductionView.buildIntroductionWithPanels(CreateBlurIntroductionPlanels.shareInstance().buildIntro(self.view.frame.size.width, height: self.view.frame.size.height))
        self.view.addSubview(introductionView)

    }
    
    // MARK: - MYIntroduction Delegate
    func introduction(introductionView: MYBlurIntroductionView!, didChangeToPanel panel: MYIntroductionPanel!, withIndex panelIndex: Int) {
        if panelIndex == 0 {
            introductionView.backgroundColor = UIColor(red: 90.0/255.0, green: 170.0/255.0, blue: 113.0/255.0, alpha: 1)
        }else if panelIndex == 1 {
            introductionView.backgroundColor = UIColor(red: 50.0/255.0, green: 79.0/255.0, blue: 133.0/255.0, alpha: 1)
        }
    }
    
    func introduction(introductionView: MYBlurIntroductionView!, didFinishWithType finishType: MYFinishType) {
        self.gotoMainViewController()
    }
    
    // MARK: - 转到主页面
    func gotoMainViewController() {
        let app: UIApplication = UIApplication.sharedApplication()
        var app2: AppDelegate = app.delegate as AppDelegate
        app2.window!.rootViewController = self.storyboard!.instantiateViewControllerWithIdentifier("ViewController") as ViewController
    }
}
