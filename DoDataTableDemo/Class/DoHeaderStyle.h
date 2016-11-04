//
//  DoRowStyle.h
//  Do_Test
//
//  Created by yz on 16/11/1.
//  Copyright © 2016年 DoExt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DoHeaderStyle : NSObject

@property (nonatomic,assign,readonly) CGFloat xZoom;
@property (nonatomic,assign,readonly) CGFloat yZoom;

@property(nonatomic,assign)     CGFloat height;
@property(nonatomic,strong)     UIColor *fontColor;
@property(nonatomic,copy)       NSString *fontStyle;
@property(nonatomic,copy)       NSString *textFlag;
@property(nonatomic,assign)     NSInteger fontSize;

-(instancetype)initWithDict:(NSDictionary *)_dictParas;
+(instancetype)doStyleWithDict:(NSDictionary *)_dictParas;
@end
