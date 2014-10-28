//
//  UIColor+StyleColor.m
//  NZAlertView
//
//  Created by Bruno Furtado on 18/12/13.
//  Copyright (c) 2013 No Zebra Network. All rights reserved.
//

#import "UIColor+StyleColor.h"

@implementation UIColor (StyleColor)

#pragma mark -
#pragma mark - Public methods

+ (UIColor *)errorColor
{
    return [UIColor colorWithRed:0.986 green:0.000 blue:0.027 alpha:1.000];
}

+ (UIColor *)infoColor
{
    return [UIColor colorWithRed:0.010 green:0.235 blue:0.998 alpha:1.000];
}

+ (UIColor *)successColor
{
    return [UIColor colorWithRed:0.082 green:0.621 blue:0.010 alpha:1.000];
}

@end