//
//  DoHeaderStyle.m
//  Do_Test
//
//  Created by yz on 16/11/1.
//  Copyright © 2016年 DoExt. All rights reserved.
//

#import "DoColumnHeaderStyle.h"
//#import "doJsonHelper.h"
//#import "doServiceContainer.h"
//#import "doILogEngine.h"
//#import "doUIModuleHelper.h"
#import "DoHelper.h"

@implementation DoColumnHeaderStyle
-(instancetype)initWithDict:(NSDictionary *)_dictParas
{
    self = [super initWithDict:_dictParas];
    if (self) {
        @try {
//            NSString *widthStr = [doJsonHelper GetOneText:_dictParas :@"width" :@"100"];
            NSString *widthStr = [_dictParas objectForKey:@"width"];
//            NSString *bgColor = [doJsonHelper GetOneText:_dictParas :@"bgColor" :@"00000000"];
            NSString *bgColor = [_dictParas objectForKey:@"bgColor"];
            self.bgColor = [DoHelper GetColorFromString:bgColor withDefault:[UIColor whiteColor]];
            //需要注意zoom
            if ([widthStr hasPrefix:@"["]) {//数组
                NSData  *rowData = [widthStr dataUsingEncoding:NSUTF8StringEncoding];
                NSError *error;
                NSArray *temp = [NSJSONSerialization JSONObjectWithData:rowData options:NSJSONReadingAllowFragments error:&error];
                if (error) {
                    [NSException raise:@"do_DataTable" format:@"setHeaderStyle方法的width参数异常"];
                }
                self.widthArray = [NSMutableArray array];
                [temp enumerateObjectsWithOptions:NSEnumerationConcurrent usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [self.widthArray addObject:@([obj floatValue] * self.xZoom)];
                }];
            }
            else
            {
                self.widthArray = [NSMutableArray arrayWithObject:@([widthStr floatValue] * self.xZoom)];
            }
        } @catch (NSException *exception) {
//            [[doServiceContainer Instance].LogEngine WriteError:exception :@"setHeaderStyle的参数异常"];
        }
    }
    return self;
}
+ (instancetype)doHeaderStyleWithDict:(NSDictionary *)_dictParas
{
    return  [[self alloc]initWithDict:_dictParas];
}
@end
