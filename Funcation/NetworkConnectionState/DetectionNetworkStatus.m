//
//  DetectionNetworkStatus.m
//  ShareRoad
//
//  Created by 枫叶 on 14/8/10.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import "DetectionNetworkStatus.h"

@implementation DetectionNetworkStatus
static DetectionNetworkStatus *instnce;

#pragma mark - 外部文件可以直接访问CustomToolClass内部函数
+ (id)shareInstance {
    if (instnce == nil) {
        instnce = [[[self class] alloc] init];
    }
    return instnce;
}

/*
 方法：检测网络的状态
 返回值：0：没有网络连接；  1：使用3G网络；  2：使用WiFi网络；
 */
+ (NSString *)checkUpNetworkStatus {
    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSString *networkStatus = @"";
    
    switch ([r currentReachabilityStatus]) {
        case NotReachable:
            // 没有网络连接
            networkStatus = @"0";
            break;
        case ReachableViaWWAN:
            // 使用3G网络
            networkStatus = @"1";
            break;
        case ReachableViaWiFi:
            // 使用WiFi网络
            networkStatus = @"2";
            break;
    }
    
    return networkStatus;
}

// 是否wifi
+ (BOOL)isEnableWifi {
    return ([[Reachability reachabilityForLocalWiFi] currentReachabilityStatus] != NotReachable);
}
// 是否3G
+ (BOOL)isEnable3G {
    return ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] != NotReachable);
}

@end
