//
//  DoHeaderStyle.h
//  Do_Test
//
//  Created by yz on 16/11/1.
//  Copyright © 2016年 DoExt. All rights reserved.
//

#import "DoHeaderStyle.h"

@interface DoColumnHeaderStyle : DoHeaderStyle
/**
 背景色
 */
@property(nonatomic,strong)     UIColor *bgColor;
/**
 宽度数组
 */
@property(nonatomic,strong)     NSMutableArray*widthArray;

-(instancetype)initWithDict:(NSDictionary *)_dictParas;
+(instancetype)doHeaderStyleWithDict:(NSDictionary *)_dictParas;
@end
