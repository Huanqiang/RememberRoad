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

/**
 *  检测网络的状态
 *
 *  @return 0：没有网络连接；  1：使用3G网络；  2：使用WiFi网络；
 */
+ (NSString *)checkUpNetworkStatus;

/**
 *  是否为WIFI
 *
 *  @return true : WIFI 网络; false : 不是 WIFI 网络
 */
+ (BOOL)isEnableWifi;

/**
 *  是否为3G
 *
 *  @return true : 3G 网络; false : 不是 3G 网络
 */
+ (BOOL)isEnable3G;

@end
