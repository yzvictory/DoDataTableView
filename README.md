
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
//column
- (NSInteger)numberOfColumn:(DoDataTableView *)formScrollView
{
    
}
//section
- (NSInteger)numberOfSection:(DoDataTableView *)formScrollView
{
    
}
//frsszeColumn
-(NSInteger)numberOfFreezeColumn:(DoDataTableView *)formScrollView
{
    
}
//columnHeight
- (CGFloat)form:(DoDataTableView *)formScrollView heightForRowAtSection:(NSInteger)section
{
    
}
//columnWidth
- (CGFloat)form:(DoDataTableView *)formScrollView widthForColumnAtColumn:(NSInteger)column
{
    
}
//column Style
- (DoColumnHeaderStyle *)styleForFormScrollView
{
    
}

- (DoFormLeftTopView *)form:(DoDataTableView *)formScrollView columnLeftTopAtColumn:(NSInteger)column
{
    
}

- (DoFormColumnHeaderView *)form:(DoDataTableView *)formScrollView columnHeaderAtColumn:(NSInteger)column
{
    
}

- (DoFormSectionHeaderView *)form:(DoDataTableView *)formScrollView sectionHeaderAtIndexPath:(DoIndexPath *)indexPath;
{
    
}
- (DoFormCell *)form:(DoDataTableView *)formScrollView cellForColumnAtIndexPath:(DoIndexPath *)indexPath
{
    
}
