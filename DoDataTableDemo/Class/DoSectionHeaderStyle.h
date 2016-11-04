//
//  DoSectionHeaderStyle.h
//  Do_Test
//
//  Created by yz on 16/11/3.
//  Copyright © 2016年 DoExt. All rights reserved.
//

#import "DoHeaderStyle.h"

@interface DoSectionHeaderStyle : DoHeaderStyle
/**
 section的背景色，取值有两个，如果为一个，所有的颜色一样；为两个时，隔行颜色一样
 */
@property (nonatomic,strong)    NSMutableArray *bgColors;
+(instancetype)sectionHeaderStyle:(NSDictionary*)_dictParas;
@end
