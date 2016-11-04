//
//  DoReusableView.h
//  Do_Test
//
//  Created by yz on 16/11/1.
//  Copyright © 2016年 DoExt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DoHeaderStyle.h"

@interface DoReusableView : UIButton
@property (nonatomic, copy, readonly) NSString *identifier;
- (instancetype)initWithIdentifier:(NSString *)identifier;
- (void)setContent:(NSString *)content withHeaderStyle:(DoHeaderStyle*)style;
@end
