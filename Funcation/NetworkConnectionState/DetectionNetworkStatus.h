//
//  DetectionNetworkStatus.h
//  ShareRoad
//
//  Created by 枫叶 on 14/8/10.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface DetectionNetworkStatus : NSObject

#pragma mark - 外部文件可以直接访问CustomToolClass内部函数
/*
 方法：外部文件可以直接访问CustomToolClass内部函数
 */
+ (id)shareInstance;

/*
 方法：检测网络的状态
 返回值：0：没有网络连接；  1：使用3G网络；  2：使用WiFi网络；
 */
+ (NSString *)checkUpNetworkStatus;

// 是否为WIFI
+ (BOOL)isEnableWifi;
// 是否3G
+ (BOOL)isEnable3G;

@end
