# DoDataTableView
企业表格
使用如下
//
//  ViewController.m
//  DoDataTableDemo
//
//  Created by yz on 16/11/4.
//  Copyright © 2016年 DeviceOne. All rights reserved.
//

#import "ViewController.h"
#import "DoDataTableView.h"
#import "DoColumnHeaderStyle.h"
#import "DoSectionHeaderStyle.h"

@interface ViewController ()<FdoFormScrollViewDelegate,FdoFormScrollViewDataSource>
{
    DoDataTableView *_formScrollView;
    
    NSMutableArray *_headerDataArray;
    NSMutableArray *_rowDataArray;
    
    DoColumnHeaderStyle *_headerStyle;
    DoSectionHeaderStyle *_rowStyle;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _formScrollView = [[DoDataTableView alloc]initWithFrame:self.view.bounds];
    [self.view addSubview:_formScrollView];
    _formScrollView.fDelegate = self;
    _formScrollView.fDataSource = self;
    _formScrollView.isHeaderVisible = YES;
    _formScrollView.backgroundColor = [UIColor lightGrayColor];
    [self initColumnHeader];
    [self initCell];
    [self commonInit];
    [_formScrollView reloadData];
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)initColumnHeader
{
    _headerDataArray = [NSMutableArray array];
    for (int column = 0; column < 10; column ++) {
        NSString *title = [NSString stringWithFormat:@"title%d",column];
        [_headerDataArray addObject:title];
    }
}

- (void)initCell
{
    _rowDataArray = [NSMutableArray arrayWithCapacity:2000];
    for (int section = 0; section < 2000; section ++) {
        NSMutableArray *columns = [NSMutableArray array];
        for (int column = 0; column < 10; column ++) {
            NSString *content = [NSString stringWithFormat:@"%d*%d",section,column];
            [columns addObject:content];
        }
        [_rowDataArray addObject:columns];
    }
}
- (void)commonInit
{
    NSDictionary *headerStyleDict = [NSDictionary dictionaryWithObjectsAndKeys:@"90",@"width",@"50",@"height",@"FFFFFF",@"bgColor",@"000000FF",@"fontColor",@"bold",@"fontStyle",@"normal",@"textFlag", @"20",@"fontSize",nil];
    _headerStyle = [DoColumnHeaderStyle doHeaderStyleWithDict:headerStyleDict];
    
    NSDictionary *rowStyleDict = [NSDictionary dictionaryWithObjectsAndKeys:@"80",@"height",@[@"FF8800",@"00FF99"],@"bgColor",@"F0F0FF",@"fontColor",@"normal",@"fontStyle",@"underline",@"textFlag",@"22",@"fontSize",nil];
    _rowStyle = [DoSectionHeaderStyle sectionHeaderStyle:rowStyleDict];
}

#pragma mark - 代理方法
- (void)form:(DoDataTableView *)formScrollView didSelectCellAtIndexPath:(DoIndexPath *)indexPath
{
    [self fireEvent:@"touch" withParma:indexPath];
}
- (void)form:(DoDataTableView *)formScrollView didSelectSessionAtIndexPath:(DoIndexPath *)indexPath
{
    [self fireEvent:@"touch" withParma:indexPath];
}
- (void)form:(DoDataTableView *)formScrollView didLongTouchCellAtIndexPath:(DoIndexPath *)indexPath
{
    [self fireEvent:@"longTouch" withParma:indexPath];
}
#pragma mark - 数据源方法 FDoDataTableViewDataSource
- (NSInteger)numberOfColumn:(DoDataTableView *)formScrollView
{
    if (_headerDataArray) {
        return _headerDataArray.count;
    }
    else
    {
        return  ((NSArray *)[_rowDataArray objectAtIndex:0]).count;
    }
}
- (NSInteger)numberOfSection:(DoDataTableView *)formScrollView
{
    return _rowDataArray.count;
}
//冻结列
-(NSInteger)numberOfFreezeColumn:(DoDataTableView *)formScrollView
{
    return 2;
}
- (CGFloat)form:(DoDataTableView *)formScrollView heightForRowAtSection:(NSInteger)section
{
    return _rowStyle.height;
}
- (CGFloat)form:(DoDataTableView *)formScrollView widthForColumnAtColumn:(NSInteger)column
{
    CGFloat width;
    if (_headerStyle.widthArray.count > 1) {
        width = [[_headerStyle.widthArray objectAtIndex:column] floatValue];
    }
    else
    {
        width = [[_headerStyle.widthArray firstObject] floatValue];
    }
    return width;
}
- (DoColumnHeaderStyle *)styleForFormScrollView
{
    return _headerStyle;
}
- (DoFormLeftTopView *)form:(DoDataTableView *)formScrollView columnLeftTopAtColumn:(NSInteger)column
{
    if (_headerDataArray.count <=0) {
        return nil;
    }
    NSString *content = [_headerDataArray objectAtIndex:column];
    DoFormLeftTopView *leftTopView = [[DoFormLeftTopView alloc]init];
    [leftTopView setContent:content withHeaderStyle:_headerStyle];
    return leftTopView;
}

- (DoFormColumnHeaderView *)form:(DoDataTableView *)formScrollView columnHeaderAtColumn:(NSInteger)column
{
    DoFormColumnHeaderView *header = [formScrollView dequeueReusableColumnWithIdentifier:@"Column"];
    if (!header) {
        header = [[DoFormColumnHeaderView alloc]initWithIdentifier:@"Column"];
    }
    NSString *content = [_headerDataArray objectAtIndex:column];
    [header setColumn:column];
    if (!content) {//headerData没有调用
        content = @"";
    }
    [header setContent:content withHeaderStyle:_headerStyle];
    return header;
}

- (DoFormSectionHeaderView *)form:(DoDataTableView *)formScrollView sectionHeaderAtIndexPath:(DoIndexPath *)indexPath;
{
    DoFormSectionHeaderView *header = [formScrollView dequeueReusableSectionWithIdentifier:@"Section"];
    if (!header) {
        header = [[DoFormSectionHeaderView alloc]initWithIdentifier:@"Section"];
    }
    NSString *content = [[_rowDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.column];
    [header setIndexPath:indexPath];
    [header setSection:indexPath.section];
    [header setContent:content withHeaderStyle:_rowStyle];
    return header;
}
- (DoFormCell *)form:(DoDataTableView *)formScrollView cellForColumnAtIndexPath:(DoIndexPath *)indexPath
{
    DoFormCell *cell = [formScrollView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[DoFormCell alloc]initWithIdentifier:@"Cell"];
    }
    NSString *content = [[_rowDataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.column];
    [cell setIndexPath:indexPath];
    [cell setContent:content withHeaderStyle:_rowStyle];
    return cell;
}
#pragma mark - 私有方法
- (void)fireEvent:(NSString *)eventName withParma:(DoIndexPath *)indexPath
{
    NSLog(@"section = %ld, column = %ld",(long)indexPath.section,(long)indexPath.column);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
