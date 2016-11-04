//
//  DoRowStyle.m
//  Do_Test
//
//  Created by yz on 16/11/1.
//  Copyright © 2016年 DoExt. All rights reserved.
//

#import "DoHeaderStyle.h"
//#import "doJsonHelper.h"
//#import "doUIModuleHelper.h"
//#import "doServiceContainer.h"
//#import "doIGlobal.h"
#import "DoHelper.h"

@interface DoHeaderStyle()

@end

@implementation DoHeaderStyle

- (instancetype)initWithDict:(NSDictionary *)_dictParas
{
    self = [super init];
    if (self) {
        [self calculateZoom];
        NSString *height = [_dictParas objectForKey:@"height"];
        self.height = [height floatValue] * _yZoom;
        NSString *fontColor = [_dictParas objectForKey:@"fontColor"];
        self.fontColor = [DoHelper GetColorFromString:fontColor withDefault:[UIColor blackColor]];
        NSString *fontStyle = [_dictParas objectForKey:@"fontStyle"];
        self.fontStyle = fontStyle;
        NSString *textFlag = [_dictParas objectForKey:@"textFlag"];
        self.textFlag = textFlag;
        int fontSize = [[_dictParas objectForKey:@"fontSize"] integerValue];
        self.fontSize = fontSize;
    }
    return self;
}
+ (instancetype)doStyleWithDict:(NSDictionary *)_dictParas
{
    return  [[self alloc]initWithDict:_dictParas];
}

- (void)calculateZoom
{
    _xZoom = 1;
    _yZoom = 1;
}
@end
