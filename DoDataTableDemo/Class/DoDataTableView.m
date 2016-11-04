//
//  doFromScrollView.m
//  Do_Test
//
//  Created by yz on 16/10/31.
//  Copyright © 2016年 DoExt. All rights reserved.
//

#import "DoDataTableView.h"
#import "DoColumnHeaderStyle.h"
#import "DoSectionHeaderStyle.h"
//#import "doServiceContainer.h"
//#import "doILogEngine.h"

@interface DoFormCell()

@end

@implementation DoFormCell
-(instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super initWithIdentifier:identifier];
    return self;
}

- (void)setIndexPath:(DoIndexPath *)indexPath
{
    _indexPath = indexPath;
}
- (void)setContent:(NSString *)content withHeaderStyle:(DoHeaderStyle *)style
{
    [super setContent:content withHeaderStyle:style];
    if (((DoSectionHeaderStyle *)style).bgColors.count > 1) {
        NSInteger index = self.indexPath.section % 2;
        UIColor *bgColor = [((DoSectionHeaderStyle *)style).bgColors objectAtIndex:index];
        self.backgroundColor = bgColor;
    }
    else{
        UIColor *bgColor = [((DoSectionHeaderStyle *)style).bgColors firstObject];
        self.backgroundColor = bgColor;
    }
}

@end

@interface DoFormColumnHeaderView()

@end
@implementation DoFormColumnHeaderView
- (instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super initWithIdentifier:identifier];
    return self;
}

- (void)setContent:(NSString *)content withHeaderStyle:(DoHeaderStyle *)style
{
    [super setContent:content withHeaderStyle:style];
    self.backgroundColor = ((DoColumnHeaderStyle *)style).bgColor;
}
- (void)setColumn:(NSInteger)column
{
    _column = column;
}

@end

@interface DoFormSectionHeaderView()

@end

@implementation DoFormSectionHeaderView
- (instancetype)initWithIdentifier:(NSString *)identifier
{
    self = [super initWithIdentifier:identifier];
    return self;
}
- (void)setContent:(NSString *)content withHeaderStyle:(DoHeaderStyle *)style
{
    [super setContent:content withHeaderStyle:style];
    if (((DoSectionHeaderStyle *)style).bgColors.count > 1) {
        NSInteger index = self.section % 2;
        UIColor *bgColor = [((DoSectionHeaderStyle *)style).bgColors objectAtIndex:index];
        self.backgroundColor = bgColor;
    }
    else{
        UIColor *bgColor = [((DoSectionHeaderStyle *)style).bgColors firstObject];
        self.backgroundColor = bgColor;
    }
}
- (void)setIndexPath:(DoIndexPath *)indexPath
{
    _indexPath = indexPath;
}
- (void)setSection:(NSInteger)section
{
    _section = section;
}
- (void)setColumn:(NSInteger)column
{
    _column = column;
}

@end

@interface DoFormLeftTopView()

@end
@implementation DoFormLeftTopView


- (void)setContent:(NSString *)content withHeaderStyle:(DoHeaderStyle *)style
{
    [super setContent:content withHeaderStyle:style];
    self.backgroundColor = ((DoColumnHeaderStyle *)style).bgColor;
}
- (void)setColumn:(NSInteger)column
{
    _column = column;
}
@end

@interface DoIndexPath()

@end
@implementation DoIndexPath

+(instancetype)indexPathForSection:(NSInteger)section inColumn:(NSInteger)column
{
    DoIndexPath *indexPath = [[DoIndexPath alloc]init];
    indexPath.section = section;
    indexPath.column = column;
    return indexPath;
}

@end

@interface DoDataTableView()
{
    NSMutableArray *_reusableColumnHeaders;
    NSMutableArray *_reusableSectionsHeaders;
    NSMutableArray *_reusableCells;
    
    DoIndexPath *_firstIndexPath;//屏幕上第一个cell的位置
    DoIndexPath *_maxIndexPath;//屏幕上最后一个cell的位置
    
    NSInteger _numberSection;
    NSInteger _numberColumn;
    NSInteger _freezeColumn;
    
    CGFloat _width;//如果headerView的宽度是一个
    CGFloat _height;// cell的高度
    
    DoColumnHeaderStyle *_headerStyle;
    
    BOOL _isMutabWidth;//列的宽度是否一样
    
    
}

@end
@implementation DoDataTableView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame  {
    if ((self = [super initWithFrame:frame])) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self commonInit];
    }
    
    return self;
}
- (void)commonInit {
    _reusableColumnHeaders = [[NSMutableArray alloc] init];
    _reusableSectionsHeaders    = [[NSMutableArray alloc] init];
    _reusableCells   = [[NSMutableArray alloc] init];
    _firstIndexPath = [DoIndexPath indexPathForSection:-1 inColumn:-1];
    _maxIndexPath = [DoIndexPath indexPathForSection:-1 inColumn:-1];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longTapAction:)];
    longPress.minimumPressDuration = 0.8; //定义按的时间
    longPress.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:longPress];
    
    self.bounces = NO;
}
#pragma mark - 复用
- (DoFormSectionHeaderView *)dequeueReusableSectionWithIdentifier:(NSString *)identifier
{
    DoFormSectionHeaderView *sectionHeader;
    for (DoFormSectionHeaderView *header in _reusableSectionsHeaders) {
        if ([header.identifier isEqualToString:identifier]) {
            sectionHeader = header;
            break;
        }
    }
    if (sectionHeader) {
        [_reusableSectionsHeaders removeObject:sectionHeader];
    }
    return sectionHeader;
}
- (DoFormColumnHeaderView *)dequeueReusableColumnWithIdentifier:(NSString *)identifier
{
    DoFormColumnHeaderView *columnHeader;
    for (DoFormColumnHeaderView *header in _reusableColumnHeaders) {
        if ([header.identifier isEqualToString:identifier]) {
            columnHeader = header;
        }
    }
    if (columnHeader) {
        [_reusableColumnHeaders removeObject:columnHeader];
    }
    return columnHeader;
}

- (DoFormCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    DoFormCell *formCell;
    for (DoFormCell *cell in _reusableCells) {
        if ([cell.identifier isEqualToString:identifier]) {
            formCell = cell;
        }
    }
    if (formCell) {
        [_reusableCells removeObject:formCell];
    }
    return formCell;
}
#pragma mark - 缓存
- (void)queueReusableCell:(DoFormCell *)cell {
    if (cell) {
        cell.indexPath = nil;
        [cell removeTarget:self action:@selector(cellClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_reusableCells addObject:cell];
    }
}
- (void)queueReusableColumnHeader:(DoFormColumnHeaderView *)columnHeader {
    if (columnHeader) {
        [columnHeader setColumn:-1];
        [columnHeader removeTarget:self action:@selector(columnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_reusableColumnHeaders addObject:columnHeader];
    }
}
- (void)queueReusableSectionHeader:(DoFormSectionHeaderView *)sectionHeader {
    if (sectionHeader){
        [sectionHeader setSection:-1];
        [sectionHeader removeTarget:self action:@selector(sectionClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [_reusableSectionsHeaders addObject:sectionHeader];
    }
}
#pragma mark - 点击事件
- (void)cellClickAction:(DoFormCell *)cell {
    if (_fDelegate) {
        if ([_fDelegate respondsToSelector:@selector(form:didSelectCellAtIndexPath:)]) {
            [_fDelegate form:self didSelectCellAtIndexPath:cell.indexPath];
        }
    }
}
- (void)columnClickAction:(DoFormColumnHeaderView *)columnView {

}
- (void)sectionClickAction:(DoFormSectionHeaderView *)sectionView {
    if (_fDelegate) {
        if ([_fDelegate respondsToSelector:@selector(form:didSelectSessionAtIndexPath:)]) {
            [_fDelegate form:self didSelectSessionAtIndexPath:sectionView.indexPath];
        }
    }
}
- (void)longTapAction:(UILongPressGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:self];
    DoIndexPath *indexPath;
    for (UIView *view in self.subviews) {
        if ([self isOnScreenRect:view.frame])
        {
            if (CGRectContainsPoint(view.frame, point)) {
                if ([view isKindOfClass:[DoFormSectionHeaderView class]]) {
                    indexPath = ((DoFormSectionHeaderView *)view).indexPath;
                }
                else if ([view isKindOfClass:[DoFormCell class]])
                {
                    indexPath = ((DoFormCell *)view).indexPath;
                }
                break;
            }
        }
    }
    
    if (_fDelegate) {
        if ([_fDelegate respondsToSelector:@selector(form:didLongTouchCellAtIndexPath:)]) {
            [_fDelegate form:self didLongTouchCellAtIndexPath:indexPath];
        }
    }
}
- (void)reloadData
{
    if (!_fDataSource) {
#if DEBUG
        NSLog(@"数据源为空");
#endif
    }
    //遍历缓存
    [[self subviews] enumerateObjectsUsingBlock:^(id obj, NSUInteger index, BOOL *stop) {
        if ([obj isKindOfClass:[DoFormColumnHeaderView class]]) {
            [self queueReusableColumnHeader:(DoFormColumnHeaderView *)obj];
            [(UIView *)obj removeFromSuperview];
        } else if ([obj isKindOfClass:[DoFormSectionHeaderView class]]) {
            [self queueReusableSectionHeader:(DoFormSectionHeaderView *)obj];
            [(UIView *)obj removeFromSuperview];
        } else if ([obj isKindOfClass:[DoFormCell class]]) {
            [self queueReusableCell:(DoFormCell *)obj];
            [(UIView *)obj removeFromSuperview];
        } else {
            [(UIView *)obj removeFromSuperview];
        }
    }];
    
    NSInteger numberSection = [_fDataSource numberOfSection:self];
    _numberSection = numberSection;
    NSInteger numberColumn = [_fDataSource numberOfColumn:self];
    _numberColumn = numberColumn;
    DoColumnHeaderStyle *style = [_fDataSource styleForFormScrollView];
    _headerStyle = style;
    _freezeColumn = [_fDataSource numberOfFreezeColumn:self];
    
    CGFloat tempWidth;
    //求出所有的宽度
    if (style.widthArray.count > 1) {
        for (id wid in style.widthArray) {
            tempWidth +=[wid floatValue];
        }
        _isMutabWidth = YES;
    }
    else
    {
        tempWidth = [[style.widthArray firstObject]floatValue] * (_numberColumn);
        _isMutabWidth = NO;
        _width = [_fDataSource form:self widthForColumnAtColumn:0];
    }
    _height = [_fDataSource form:self heightForRowAtSection:0];
    //滚动区域
    self.contentSize = CGSizeMake(tempWidth, _numberSection*_height + style.height);
    
    //写在这里避免滑动多次addSubview
    [self clearUpLeftTopView];
    [self drawLeftTopView];
    [self setNeedsLayout];
}
- (void)layoutSubviews {
    [super layoutSubviews];
    [self cleanupUnseenItems];
    [self loadseenItems];
    //把leftTopView放置到view的最上面
    [self bringletTopViewToFront];
}
//清除屏幕之外的view
- (void)cleanupUnseenItems
{
    _firstIndexPath = [DoIndexPath indexPathForSection:_numberSection inColumn:_numberColumn];
    _maxIndexPath = [DoIndexPath indexPathForSection:0 inColumn:0];
    for (UIView *view in self.subviews)
    {
        if (![self isOnScreenRect:view.frame])//不在屏幕上复用
        {
            if ([view isKindOfClass:[DoFormCell class]]) {
                DoFormCell*cell = (DoFormCell *)view;
                [self queueReusableCell:cell];
                [cell removeFromSuperview];
            } else if ([view isKindOfClass:[DoFormSectionHeaderView class]]) {
                DoFormSectionHeaderView*header = (DoFormSectionHeaderView *)view;
                header.frame = CGRectMake(self.contentOffset.x+self.contentInset.left + CGRectGetMinX(header.frame), CGRectGetMinY(header.frame), CGRectGetWidth(header.frame), CGRectGetHeight(header.frame));
                if (![self isOnScreenRect:header.frame]) {
                    [self queueReusableSectionHeader:header];
                    [header removeFromSuperview];
                }
            } else if ([view isKindOfClass:[DoFormColumnHeaderView class]]) {
                DoFormColumnHeaderView*header = (DoFormColumnHeaderView *)view;
                header.frame = CGRectMake(CGRectGetMinX(header.frame), self.contentOffset.y+self.contentInset.top, CGRectGetWidth(header.frame), CGRectGetHeight(header.frame));
                if (![self isOnScreenRect:header.frame]) {
                    [self queueReusableColumnHeader:header];
                    [header removeFromSuperview];
                }
            }
            else if([view isKindOfClass:[DoFormLeftTopView class]])
            {
                DoFormLeftTopView *leftTop = (DoFormLeftTopView*)view;
                NSInteger column = leftTop.column;
                CGFloat leftX = [self getWidthFromColumn:column];
                leftTop.frame =CGRectMake(leftX + self.contentOffset.x ,self.contentOffset.y + self.contentInset.top , CGRectGetWidth(leftTop.frame), CGRectGetHeight(leftTop.frame));
            }
        }
        else{//在屏幕上更新frame
            if ([view isKindOfClass:[DoFormLeftTopView class]]) {
                DoFormLeftTopView *leftTop = (DoFormLeftTopView*)view;
                NSInteger column = leftTop.column;
                CGFloat leftX = [self getWidthFromColumn:column];
                leftTop.frame =CGRectMake(leftX + self.contentOffset.x ,self.contentOffset.y + self.contentInset.top , CGRectGetWidth(leftTop.frame), CGRectGetHeight(leftTop.frame));
            }
            else if ([view isKindOfClass:[DoFormSectionHeaderView class]]) {
                DoFormSectionHeaderView*header = (DoFormSectionHeaderView *)view;
                NSInteger column = header.column;
                CGFloat leftX = [self getWidthFromColumn:column];
                header.frame = CGRectMake(leftX + self.contentOffset.x+self.contentInset.left, CGRectGetMinY(header.frame), CGRectGetWidth(header.frame), CGRectGetHeight(header.frame));
            } else if ([view isKindOfClass:[DoFormColumnHeaderView class]]) {
                DoFormColumnHeaderView*header = (DoFormColumnHeaderView *)view;
                header.frame = CGRectMake(CGRectGetMinX(header.frame), self.contentOffset.y+self.contentInset.top, CGRectGetWidth(header.frame), CGRectGetHeight(header.frame));
            } else if ([view isKindOfClass:[DoFormCell class]]) {
                DoFormCell*cell = (DoFormCell *)view;
                if (cell.indexPath.section<=_firstIndexPath.section && cell.indexPath.column<=_firstIndexPath.column) {
                    _firstIndexPath = [DoIndexPath indexPathForSection:cell.indexPath.section inColumn:cell.indexPath.column];
                }
                if (cell.indexPath.section>=_maxIndexPath.section && cell.indexPath.column>=_maxIndexPath.column) {
                    _maxIndexPath = [DoIndexPath indexPathForSection:cell.indexPath.section inColumn:cell.indexPath.column];
                }
            }
        }
        
    }
}
//更新屏幕上的view
- (void)loadseenItems
{
    //绘制表格
    @try {
        [self drawColumnHeaderView];
        [self drawSectionHeaderView];
        [self drawCellView];
    } @catch (NSException *exception) {
//        [[doServiceContainer Instance].LogEngine WriteError:exception :@"setHeaderStyle宽度的个数与setHeaderData不一致"];
    }
}
- (void)drawCellView
{
    //头部是否可见
    CGFloat topY = 0;
    if (_isHeaderVisible) {
        topY = _headerStyle.height;
    }
    for (NSInteger section = 0; section < _numberSection; section ++) {
        //屏幕上下区域处理
        if (section*_height>self.contentOffset.y+self.frame.size.height
            || (section+1)*_height<self.contentOffset.y) {
            continue;
        }
        for (NSInteger column = _freezeColumn; column < _numberColumn; column ++) {
            CGFloat tempCurW = [self getWidthFromColumn:column];
            if (_isMutabWidth) {//多个宽度
                CGFloat currentColW;
                if (column >= _headerStyle.widthArray.count) {
                    currentColW = [[_headerStyle.widthArray lastObject] floatValue];
                }
                else
                {
                    currentColW = [[_headerStyle.widthArray objectAtIndex:column] floatValue];
                }
                //处理屏幕左边或者右边
                if (tempCurW > self.contentOffset.x + self.frame.size.width || (tempCurW + currentColW) < self.contentOffset.x) {
                    continue;
                }
                if (column>=_firstIndexPath.column
                    &&column<=_maxIndexPath.column
                    &&section>=_firstIndexPath.section
                    &&section<=_maxIndexPath.section) {
                    continue;
                }
                CGRect rect = CGRectMake(tempCurW, topY + section * _height , currentColW, _height);
                if ([self isOnScreenRect:rect]) {
                    DoIndexPath *indexPath = [DoIndexPath indexPathForSection:section inColumn:column];
                    DoFormCell *cell = [_fDataSource form:self cellForColumnAtIndexPath:indexPath];
                    [cell addTarget:self action:@selector(cellClickAction:) forControlEvents:UIControlEventTouchUpInside];
                    cell.frame = rect;
                    [self insertSubview:cell atIndex:0];
                }
            }
            else//单个宽度
            {
                if (column*_width>self.contentOffset.x+self.frame.size.width
                    || (column+1)*_width<self.contentOffset.x) {
                    continue;
                }
                if (column>=_firstIndexPath.column
                    &&column<=_maxIndexPath.column
                    &&section>=_firstIndexPath.section
                    &&section<=_maxIndexPath.section) {
                    continue;
                }
                CGRect rect = CGRectMake(column*_width,topY + section*_height, _width, _height);
                if ([self isOnScreenRect:rect]) {
                    DoIndexPath *indexPath = [DoIndexPath indexPathForSection:section inColumn:column];
                    DoFormCell *cell = [_fDataSource form:self cellForColumnAtIndexPath:indexPath];
                    [cell addTarget:self action:@selector(cellClickAction:) forControlEvents:UIControlEventTouchUpInside];
                    cell.frame = rect;
                    cell.indexPath = indexPath;
                    [self insertSubview:cell atIndex:0];
                }
            }
        }
    }
}
- (void)drawSectionHeaderView
{
    CGFloat topY = 0;
    if (self.isHeaderVisible) {
        topY = _headerStyle.height;
    }
    for (NSInteger section = 0; section < _numberSection; section ++) {
        //屏幕上下区域处理
        if (section*_height>self.contentOffset.y+self.frame.size.height
            || (section+1)*_height<self.contentOffset.y) {
            continue;
        }
        //冻结列
        for (NSInteger column = 0; column < _freezeColumn; column ++) {
            if (_isMutabWidth) {//多个宽度
                CGFloat currentColW;
                
                if (column >= _headerStyle.widthArray.count) {
                    currentColW = [[_headerStyle.widthArray lastObject] floatValue];
                }
                else
                {
                    currentColW = [[_headerStyle.widthArray objectAtIndex:column] floatValue];
                }
                CGFloat tempCurW = [self getWidthFromColumn:column];
                if (section>=_firstIndexPath.section
                    &&section<=_maxIndexPath.section) {
                    continue;
                }
                CGRect rect = CGRectMake(tempCurW + self.contentOffset.x + self.contentInset.left, _height*section + topY, currentColW, _height);
                if ([self isOnScreenRect:rect]) {
                    DoIndexPath *indexPath = [DoIndexPath indexPathForSection:section inColumn:column];
                    DoFormSectionHeaderView *header = [_fDataSource form:self sectionHeaderAtIndexPath:indexPath];
                    [header addTarget:self action:@selector(sectionClickAction:) forControlEvents:UIControlEventTouchUpInside];
                    header.frame = rect;
                    [header setColumn:column];
                    [self insertSubview:header atIndex:1];
                    
                }
            }
            else//单个宽度
            {
                if (section>=_firstIndexPath.section
                    &&section<=_maxIndexPath.section) {
                    continue;
                }
                CGRect rect = CGRectMake(column*_width + + self.contentOffset.x + self.contentInset.left, _height* section + topY, _width, _height);
                if ([self isOnScreenRect:rect]) {
                    DoIndexPath *indexPath = [DoIndexPath indexPathForSection:section inColumn:column];
                    DoFormSectionHeaderView *header = [_fDataSource form:self sectionHeaderAtIndexPath:indexPath];
                    [header addTarget:self action:@selector(sectionClickAction:) forControlEvents:UIControlEventTouchUpInside];
                    header.frame = rect;
                    [header setColumn:column];
                    [self insertSubview:header atIndex:1];
                }
            }
        }
    }
}

- (void)clearUpLeftTopView
{
    for (UIView *view in self.subviews)
    {
        if ([view isKindOfClass:[DoFormLeftTopView class]]) {
            [view removeFromSuperview];
        }
    }
}
- (void)drawLeftTopView
{
    //头部可见
    if (self.isHeaderVisible) {
        //1.绘制LeftTop
        CGFloat currentH = _headerStyle.height;
        for (NSInteger column = 0; column < _freezeColumn; column ++) {
            DoFormLeftTopView *leftTop = [_fDataSource form:self columnLeftTopAtColumn:column];
            CGFloat leftX = [self getWidthFromColumn:column];
            if (_isMutabWidth) {//多个宽度
                CGFloat currentW = [[_headerStyle.widthArray objectAtIndex:column] floatValue];
                leftTop.frame = CGRectMake(leftX, 0, currentW, currentH);
            }
            else
            {
                leftTop.frame = CGRectMake(leftX , 0, _width, currentH);
            }
            [leftTop setColumn:column];
            [self addSubview:leftTop];
        }
    }
}
- (void)drawColumnHeaderView
{
    //2.绘制columnHeader
    if (self.isHeaderVisible) {
        CGFloat leftX;
        for (NSInteger column = _freezeColumn; column < _numberColumn; column ++) {
            //2.1有多个宽度
            if (_isMutabWidth) {
                CGFloat currentColW;
                if (column >= _headerStyle.widthArray.count) {
                    currentColW = [[_headerStyle.widthArray lastObject] floatValue];
                }
                else
                {
                    currentColW = [[_headerStyle.widthArray objectAtIndex:column] floatValue];
                }
                leftX = [self getWidthFromColumn:column];
                //处理屏幕左边或者右边
                if (leftX > self.contentOffset.x + self.frame.size.width || (leftX + currentColW) < self.contentOffset.x) {
                    continue;
                }
                if (column >= _firstIndexPath.column && column <= _maxIndexPath.column) {
                    continue;
                }
                CGRect rect = CGRectMake(leftX, self.contentOffset.y + self.contentInset.top, currentColW, _headerStyle.height);
                if ([self isOnScreenRect:rect]) {
                    DoFormColumnHeaderView *header = [_fDataSource form:self columnHeaderAtColumn:column];
                    header.frame = rect;
                    [self insertSubview:header atIndex:1];
                }
            }
            else//2.2只有一个宽度
            {
                if (column*_width>self.contentOffset.x+self.frame.size.width
                    || (column+1)*_width<self.contentOffset.x) {
                    continue;
                }
                if (column>=_firstIndexPath.column
                    &&column<=_maxIndexPath.column) {
                    continue;
                }
                CGRect rect = CGRectMake((column)*_width, self.contentOffset.y+self.contentInset.top, _width, _headerStyle.height);
                if ([self isOnScreenRect:rect]) {
                    DoFormColumnHeaderView *header = [_fDataSource form:self columnHeaderAtColumn:column];
                    header.frame = rect;
                    [self insertSubview:header atIndex:1];
                }
            }
        }
    }
}

- (void)bringletTopViewToFront
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[DoFormLeftTopView class]]) {
            [self bringSubviewToFront:view];
        }
    }
}

- (BOOL)isOnScreenRect:(CGRect)rect {
    return CGRectIntersectsRect(rect, CGRectMake(self.contentOffset.x, self.contentOffset.y, self.frame.size.width, self.frame.size.height));
}

- (CGFloat)getWidthFromColumn:(NSInteger)column
{
    if (_isMutabWidth) {
        CGFloat totalLeftW = 0;
        for (NSInteger index = 0; index < column; index ++) {
            CGFloat tempW;
            if (index >= _headerStyle.widthArray.count) {
                tempW = [[_headerStyle.widthArray lastObject] floatValue];
            }
            else
            {
                tempW = [[_headerStyle.widthArray objectAtIndex:index] floatValue];
            }
            totalLeftW += tempW;
        }
        return totalLeftW;
    }else{
        return column * _width;
    }
}
@end
























