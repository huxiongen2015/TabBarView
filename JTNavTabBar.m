//
//  JTNavTabBar.m
//  TestApp
//
//  Created by 胡雄恩 on 15/6/9.
//  Copyright (c) 2015年 胡雄恩. All rights reserved.
//

#import "JTNavTabBar.h"
#import "CommonMacro.h"

@interface JTNavTabBar ()
{
    UIScrollView    *_navgationTabBar;      // all items on this scroll view
    
    UIView          *_line;                 // underscore show which item selected
    
    NSMutableArray  *_items;                // SCNavTabBar pressed item
    NSArray         *_itemsWidth;           // an array of items' width
    BOOL            _showArrowButton;       // is showed arrow button
    
    int             _lineWidth; //线的宽度
    
    NSMutableArray         *_buttonArr;            //所有itembtn
    
    int             _selectIndex;                   //前一个选中的
    
    UIView *_xian;
    
}

@end

@implementation JTNavTabBar

- (id)initWithFrame:(CGRect)frame showArrowButton:(BOOL)show
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _showArrowButton = show;
        
        [self initConfig];
    }
    return self;
}

- (void)initConfig
{
    _items = [@[] mutableCopy];
    _buttonArr = [[NSMutableArray alloc]init];
    [self viewConfig];
}

- (void)viewConfig
{
    _navgationTabBar = [[UIScrollView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, DOT_COORDINATE, SCREEN_WIDTH, NAV_TAB_BAR_HEIGHT)];
    _navgationTabBar.showsHorizontalScrollIndicator = NO;
    [self addSubview:_navgationTabBar];
}

- (void)showLineWithButtonWidth:(CGFloat)width
{
    _lineWidth = width;
    _line = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 76*kHy - 3.0f, width - 4.0f, 3.0f)];
    _line.backgroundColor = LZColor(67, 174, 242);
    [_navgationTabBar addSubview:_line];
}
//_itemTitles
//无限排
- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidth:(NSArray *)widths
{
    CGFloat buttonX = DOT_COORDINATE;
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, DOT_COORDINATE, [widths[index] floatValue], 76*kHy);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:kHx *32];
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        if( index == 0 )
            [button setTitleColor:LZColor(67, 174, 242) forState:UIControlStateNormal];
        else
            [button setTitleColor:LZColor(128, 130, 131) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_navgationTabBar addSubview:button];
        [_items addObject:button];
        buttonX += [widths[index] floatValue];
        [_buttonArr addObject:button];
    }
    
    [self showLineWithButtonWidth:[widths[0] floatValue]];
    return buttonX;
}

//一排放满
- (CGFloat)contentWidthAndAddNavTabBarItemsWithButtonsWidthMax:(NSArray *)widths
{
    CGFloat buttonX = DOT_COORDINATE;
    for (NSInteger index = 0; index < [_itemTitles count]; index++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, DOT_COORDINATE, kScreenWid/[_itemTitles count], 76*kHy);
        button.titleLabel.font = [UIFont boldSystemFontOfSize:kHx *32];
        if( index == 0 )
            [button setTitleColor:LZColor(67, 174, 242) forState:UIControlStateNormal];
        else
            [button setTitleColor:LZColor(128, 130, 131) forState:UIControlStateNormal];
        [button setTitle:_itemTitles[index] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_navgationTabBar addSubview:button];
        [_items addObject:button];
        buttonX += ( kScreenWid/[_itemTitles count] );
        [_buttonArr addObject:button];
    }
    [self showLineWithButtonWidthMax:( kScreenWid/[_itemTitles count] )];
    return buttonX;
}

- (void)showLineWithButtonWidthMax:(CGFloat)width
{
    _lineWidth = width;
    _line = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 76*kHy - 3.0f, width, 3.0f)];
    _line.backgroundColor = LZColor(67, 174, 242);
    [_navgationTabBar addSubview:_line];
}

- (void)itemPressed:(UIButton *)button
{
    NSInteger index = [_items indexOfObject:button];
    [_delegate itemDidSelectedWithIndex:index];
}

- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    for (NSString *title in titles)
    {
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]}];
        NSNumber *width = [NSNumber numberWithFloat:size.width + 40.0f];
        [widths addObject:width];
    }
    return widths;
}

- (void)viewShowShadow:(UIView *)view shadowRadius:(CGFloat)shadowRadius shadowOpacity:(CGFloat)shadowOpacity
{
    view.layer.shadowRadius = shadowRadius;
    view.layer.shadowOpacity = shadowOpacity;
}

//拖动时更新
- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    _currentItemIndex = currentItemIndex;
    UIButton *button = _items[currentItemIndex];
    CGFloat flag = _showArrowButton ? (SCREEN_WIDTH - ARROW_BUTTON_WIDTH) : SCREEN_WIDTH;

    if( (button.frame.origin.x + button.frame.size.width+50) >= flag )
    {
        CGFloat offsetX = button.frame.origin.x + button.frame.size.width - flag;
        if (_currentItemIndex < [_itemTitles count] - 1)
        {
            UIButton *btn2 = _items[currentItemIndex+1];
            offsetX = offsetX + btn2.frame.size.width;
        } else{
            UIButton *btn = _items[currentItemIndex];
            offsetX = button.frame.origin.x +  btn.frame.size.width - flag;
        }
        [_navgationTabBar setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
    else
    {
        [_navgationTabBar setContentOffset:CGPointMake(0, 0) animated:YES];
    }
  
    [UIView animateWithDuration:0.2f animations:^{ //动画
         _line.frame = CGRectMake(button.frame.origin.x , _line.frame.origin.y, button.frame.size.width, _line.frame.size.height);
    }];
    UIButton *btn = [_buttonArr objectAtIndex:currentItemIndex];
    [btn setTitleColor:LZColor(67, 174, 242) forState:UIControlStateNormal];
    if( _selectIndex == currentItemIndex ) return;
    btn = [_buttonArr objectAtIndex:_selectIndex];
    [btn setTitleColor:LZColor(128, 130, 131) forState:UIControlStateNormal];
    _selectIndex = (int)_currentItemIndex;
}


- (void)updateData
{
    _itemsWidth = [self getButtonsWidthWithTitles:_itemTitles];
    CGFloat contentWidth;
    if (_itemsWidth.count)
    {
        if( _contenButtonsWidthMax )
            contentWidth= [self contentWidthAndAddNavTabBarItemsWithButtonsWidthMax:_itemsWidth];
        else
            contentWidth = [self contentWidthAndAddNavTabBarItemsWithButtonsWidth:_itemsWidth];
        _navgationTabBar.contentSize = CGSizeMake(contentWidth, DOT_COORDINATE);
    }
    [self setXianW:contentWidth];
}
-(void)setXianW:(int)wid
{
    _xian = [[UIView alloc]initWithFrame:CGRectMake(0, 76*kHy, wid, 0.5)];
    _xian.backgroundColor = LZColor(69, 175, 242);
    [_navgationTabBar addSubview:_xian];
}

@end