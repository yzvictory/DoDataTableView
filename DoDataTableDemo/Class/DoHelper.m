//
//  DoHelper.m
//  DoDataTableDemo
//
//  Created by yz on 16/11/4.
//  Copyright © 2016年 DeviceOne. All rights reserved.
//

#import "DoHelper.h"


@implementation DoHelper
+ (UIColor*) GetColorFromString: (NSString*) _colorStr withDefault: (UIColor*) _default
{
    // 显示颜色  配置文件 配置颜色透明度
    if ([_colorStr hasPrefix:@"#"]){
        _colorStr = [_colorStr stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
    
    
    float showAlpha = 1.0;
    if ([_colorStr length]>6 && [_colorStr length]==8) {
        NSString *alpha = [_colorStr substringFromIndex:6];
        showAlpha = [self ToHex:alpha]/255.0;
        _colorStr = [_colorStr substringWithRange:NSMakeRange(0, 6)];
    }
    
    if (_colorStr == nil || [_colorStr length]<= 0)
        return _default;
    if (![_colorStr hasPrefix:@"#"])
        _colorStr = [@"#" stringByAppendingString:  _colorStr];
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:_colorStr];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:showAlpha];
}
//private
+(int)ToHex:(NSString*)tmpid
{
    int int_ch;
    
    unichar hex_char1 = [tmpid characterAtIndex:0]; ////两位16进制数中的第一位(高位*16)
    int int_ch1;
    if(hex_char1 >= '0'&& hex_char1 <='9')
        int_ch1 = (hex_char1-48)*16;   //// 0 的Ascll - 48
    else if(hex_char1 >= 'A'&& hex_char1 <='F')
        int_ch1 = (hex_char1-55)*16; //// A 的Ascll - 65
    else
        int_ch1 = (hex_char1-87)*16; //// a 的Ascll - 97
    
    
    unichar hex_char2 = [tmpid characterAtIndex:1]; ///两位16进制数中的第二位(低位)
    int int_ch2;
    if(hex_char2 >= '0'&& hex_char2 <='9')
        int_ch2 = (hex_char2-48); //// 0 的Ascll - 48
    else if(hex_char1 >= 'A'&& hex_char1 <='F')
        int_ch2 = hex_char2-55; //// A 的Ascll - 65
    else
        int_ch2 = hex_char2-87; //// a 的Ascll - 97
    
    int_ch = int_ch1+int_ch2;
    //NSLog(@"int_ch=%d",int_ch);
    
    return int_ch;
}


@end
