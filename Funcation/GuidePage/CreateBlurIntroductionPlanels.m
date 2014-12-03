//
//  CreateBlurIntroductionPlanels.m
//  TemplateProject
//
//  Created by wanghuanqiang on 14/10/19.
//  Copyright (c) 2014年 枫叶. All rights reserved.
//

#import "CreateBlurIntroductionPlanels.h"

@implementation CreateBlurIntroductionPlanels

static CreateBlurIntroductionPlanels *instnce;
#pragma mark - 对外接口
//使外部文件可以直接访问UesrDB内部函数
+ (id)shareInstance {
    if (instnce == nil) {
        instnce = [[[self class] alloc] init];
    }
    return instnce;
}


-(NSArray *)buildIntro:(CGFloat)width height:(CGFloat)height{
    //Create Stock Panel with header
    UIView *headerView = [[NSBundle mainBundle] loadNibNamed:@"PanelOfGuideHeader" owner:nil options:nil][0];
    MYIntroductionPanel *panel1 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, width, height) title:@"帮你重现来时的路" description:@"\n\n你还在因为自己的路痴为找不到回家的路？\n\n不用担心，有“记路”." image:[UIImage imageNamed:@"lose.png"] header:headerView];
    
    //Create Stock Panel With Image
    MYIntroductionPanel *panel2 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, width, height) title:@"一键拨打" description:@"\n\n快设置的你最亲密的联系人吧，一键即 call 哟!" image:[UIImage imageNamed:@"call.png"]];
    
    //Create Panel From Nib
    MYIntroductionPanel *panel3 = [[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, width, height) nibNamed:@"PanelOfGuide"];
    
    //Create custom panel with events
    //    MYCustomPanel *panel4 = [[MYCustomPanel alloc] initWithFrame:CGRectMake(0, 0, width, height) nibNamed:@"MYCustomPanel"];
    
    //Add panels to an array
    NSArray *panels = @[panel1, panel2, panel3];
    
    return panels;
}

@end
