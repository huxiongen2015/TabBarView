//
//  JTNavTabBarController.m
//  TestApp
//
//  Created by 胡雄恩 on 15/6/9.
//  Copyright (c) 2015年 胡雄恩. All rights reserved.
//

#import "JTNavTabBarView.h"
#import "CommonMacro.h"
#import "JTNavTabBar.h"
#import "JTView.h"

@interface JTNavTabBarView() <UIScrollViewDelegate, JTNavTabBarDelegate>
{
    NSInteger       _currentIndex;              // current page index
    NSMutableArray  *_titles;                   // array of children view controller's title
    
    JTNavTabBar     *_navTabBar;                // NavTabBar: press item on it to exchange view
    UIScrollView    *_scrollView;                 // content view
    
    BOOL bo;//是否需要直接跳某个界面
    
    BOOL _bool_views;/**< 添加了views */
    
    NSMutableArray *_array_views;/**< 所有view */
}
@end

@implementation JTNavTabBarView
- (id)initWithShowArrowButton:(BOOL)show
{
    self = [super init];
    if (self)
    {
        _showArrowButton = show;
    }
    return self;
}

- (void)viewDid
{
    _currentIndex = 0;
    [self showTitles];
}

//显示titles标题的距离
-(void)showTitles
{
    _navTabBarColor = _navTabBarColor ? _navTabBarColor : NavTabbarColor;

    _titles = [[NSMutableArray alloc] initWithCapacity:_showTitlesArr.count];
    for ( NSString *str in _showTitlesArr)
    {
        if(str == nil || [str isEqualToString:@""])
        {
            NSLog(@"名字没设置");
            return;
        }
        [_titles addObject:str];
    }
}

- (void)viewInit:(int)y
{
    _navTabBar = [[JTNavTabBar alloc] initWithFrame:CGRectMake(DOT_COORDINATE, y, SCREEN_WIDTH, 76*kHy) showArrowButton:_showArrowButton];
    _navTabBar.delegate = self;
    _navTabBar.contenButtonsWidthMax = _contenButtonsWidthMax;
    _navTabBar.backgroundColor = _navTabBarColor;
    _navTabBar.lineColor = _navTabBarLineColor;
    _navTabBar.itemTitles = _titles;
    [_navTabBar updateData];
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(DOT_COORDINATE, _navTabBar.frame.origin.y + _navTabBar.frame.size.height+0.5, SCREEN_WIDTH, SCREEN_HEIGHT - _navTabBar.frame.origin.y - _navTabBar.frame.size.height - STATUS_BAR_HEIGHT - NAVIGATION_BAR_HEIGHT)];
    _scrollView.delegate = self;
    [self addSubview:_navTabBar];
}

-(void)setView:(NSMutableArray *)arr
{
    _array_views = arr;
    _bool_views = YES;
    _scrollView.pagingEnabled = YES;/**< 分页 */
    _scrollView.directionalLockEnabled = YES;
    JTView *view;
    for (int i =0; i<[arr count]; i++) {
        view = [arr objectAtIndex:i];
        [_scrollView addSubview:view];
        if(i==0){
            view.bo = YES;
            [view showUI];
        }
    }
    _scrollView.contentSize = CGSizeMake(kScreenWid*[arr count], kScreenHight-76*kHy-64);
    _scrollView.bounces = NO;/**< 是否反弹 */
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:_scrollView];
}

- (void)addParentController
{
    UISwipeGestureRecognizer *s =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
    s.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *b =[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
    b.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self addGestureRecognizer:s];
    [self addGestureRecognizer:b];
}

-(void)test:(UISwipeGestureRecognizer *)swip
{
    if( swip.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        if(_currentIndex == [_titles count] - 1 )return;
        _currentIndex += 1;
    } else if( swip.direction  == UISwipeGestureRecognizerDirectionRight)
    {
        if( _currentIndex == 0 )return;
        _currentIndex -= 1;
    }
    _navTabBar.currentItemIndex = _currentIndex;
    if(_callBack != nil)
         _callBack((int)_currentIndex);
}

#pragma mark - Scroll View Delegate Methods
#pragma mark -
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(bo == NO) return;
    
    _currentIndex = scrollView.contentOffset.x / SCREEN_WIDTH;
    if(_currentIndex <= 0 )return;
    _navTabBar.currentItemIndex = _currentIndex;
    bo = NO;
    if(_bool_views==YES)
    {
        if( _currentIndex > [_array_views count]-1 )return;
        JTView *view = [_array_views objectAtIndex:_currentIndex];
        if(view.bo==YES) return;
        view.bo = YES;
        [view showUI];
    }
}

// scrollview 减速停止
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if(_bool_views==YES)
    {
        float index = scrollView.contentOffset.x / SCREEN_WIDTH;
        _currentIndex = index+0.5;
        _navTabBar.currentItemIndex = _currentIndex;
        if(_callBack == nil){
            _callBack((int)_currentIndex);
        }
        if( _currentIndex > [_array_views count] -1)return;
        JTView *view = [_array_views objectAtIndex:_currentIndex];
        if(view.bo==YES) return;
        view.bo = YES;
        [view showUI];
    }
}

-(void)dealloc
{
//    LZLog(@"移除");
}

#pragma mark - SCNavTabBarDelegate Methods
#pragma mark -
- (void)itemDidSelectedWithIndex:(NSInteger)index
{
    bo = YES;
    [_scrollView setContentOffset:CGPointMake(index * SCREEN_WIDTH, DOT_COORDINATE) animated:_scrollAnimation];
    if( index == 0 ){
        _currentIndex = 0;
        _navTabBar.currentItemIndex = 0;
    }
    if(_callBack != nil)
        _callBack((int)_currentIndex);
   
}
@end
