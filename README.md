# 表格展示

## 功能
* 支持设置标头
* 支持固定列
* 支持设置简单的样式，比如字体颜色，样式，背景色等。
  
##效果
![MacDown logo](https://github.com/yzvictory/DoDataTableView/blob/master/Images/Screen1.png)
![MacDown logo](https://github.com/yzvictory/DoDataTableView/blob/master/Images/Screen2.png)
![MacDown logo](https://github.com/yzvictory/DoDataTableView/blob/master/Images/show.gif)
##使用
**代理方法**  

```objc
//点击cell
- (void)form:(DoDataTableView *)formScrollView didSelectCellAtIndexPath:(DoIndexPath *)indexPath
{
    
}
//点击冻结列
- (void)form:(DoDataTableView *)formScrollView didSelectSessionAtIndexPath:(DoIndexPath *)indexPath
{
    
}
//长按
- (void)form:(DoDataTableView *)formScrollView didLongTouchCellAtIndexPath:(DoIndexPath *)indexPath
{

}
```  
**数据源方法**  

```
//column
- (NSInteger)numberOfColumn:(DoDataTableView *)formScrollView
{
    
}
// row
- (NSInteger)numberOfSection:(DoDataTableView *)formScrollView
{
    
}
//冻结列
-(NSInteger)numberOfFreezeColumn:(DoDataTableView *)formScrollView
{
    
}
//height
- (CGFloat)form:(DoDataTableView *)formScrollView heightForRowAtSection:(NSInteger)section
{
    
}

// style
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

```

