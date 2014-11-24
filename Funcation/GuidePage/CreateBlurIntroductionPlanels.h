//
//  CreateBlurIntroductionPlanels.h
//  TemplateProject
//
//  Created by wanghuanqiang on 14/10/19.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MYBlurIntroductionView.h"

@interface CreateBlurIntroductionPlanels : NSObject

#pragma mark - 对外接口
//使外部文件可以直接访问UesrDB内部函数
+ (id)shareInstance;

-(NSArray *)buildIntro:(CGFloat)width height:(CGFloat)height;

@end
