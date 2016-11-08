//
//  DoReusableView.m
//  Do_Test
//
//  Created by yz on 16/11/1.
//  Copyright © 2016年 DoExt. All rights reserved.
//

#import "DoReusableView.h"

@implementation DoReusableView

-(instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super init];
    _identifier = identifier;
    return self;
}
- (void)setContent:(NSString *)content withHeaderStyle:(DoHeaderStyle *)style
{
    if([style.fontStyle isEqualToString:@"normal"])
        [self.titleLabel setFont:[UIFont systemFontOfSize:style.fontSize]];
    else if([style.fontStyle isEqualToString:@"bold"])
    {
        [self.titleLabel setFont:[UIFont boldSystemFontOfSize:style.fontSize]];
    }
    else if([style.fontStyle isEqualToString:@"italic"])
    {
        CGAffineTransform matrix =  CGAffineTransformMake(1, 0, tanf(15 * (CGFloat)M_PI / 180), 1, 0, 0);
        UIFontDescriptor *desc = [ UIFontDescriptor fontDescriptorWithName :[ UIFont systemFontOfSize :style.fontSize ]. fontName matrix :matrix];
        [self.titleLabel setFont:[ UIFont fontWithDescriptor :desc size :style.fontSize]];
    }
    else if([style.fontStyle isEqualToString:@"bold_italic"]){}
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:content];
    NSRange titleRange = {0,[title length]};
    if ([style.textFlag isEqualToString:@"normal"]) {
        
    }
    else if ([style.textFlag isEqualToString:@"underline"])
    {
        [title addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    }
    else if ([style.textFlag isEqualToString:@"strikethrough"])
    {
        [title addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:titleRange];
    }
    [title addAttribute:NSForegroundColorAttributeName value:style.fontColor range:titleRange];
    [self setAttributedTitle:title forState:UIControlStateNormal];
}
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGPoint aPoints[5];
    aPoints[0] =CGPointMake(0, 0);
    aPoints[1] =CGPointMake(CGRectGetWidth(rect), 0);
    aPoints[2] =CGPointMake(CGRectGetWidth(rect), CGRectGetHeight(rect));
    aPoints[3] =CGPointMake(0, CGRectGetHeight(rect));
    aPoints[4] =CGPointMake(0, 0);
    CGContextAddLines(context, aPoints, 5);
    CGContextDrawPath(context, kCGPathStroke);
}
@end
