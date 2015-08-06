//
//  JTNavTabBarController.h
//  TestApp
//
//  Created by 胡雄恩 on 15/6/9.
//  Copyright (c) 2015年 胡雄恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SCNavTabBar;

typedef void(^callBacks)(int index);

@interface JTNavTabBarView : UIView
// 本控件高度76*kHy

@property (nonatomic, assign)   BOOL        showArrowButton;            // Default value: YES
@property (nonatomic, assign)   BOOL        scrollAnimation;            // Default value: NO
//@property (nonatomic, assign)   BOOL        mainViewBounces;            // Default value: NO

//@property (nonatomic, strong)   NSArray     *subViewControllers;        // An array of children view controllers

@property (nonatomic, strong)   UIColor     *navTabBarColor;            // Could not set [UIColor clear], if you set, NavTabbar will show initialize color
@property (nonatomic, strong)   UIColor     *navTabBarLineColor;
//@property (nonatomic, strong)   UIImage     *navTabBarArrowImage;
@property (nonatomic, copy) callBacks callBack;

@property NSMutableArray *showTitlesArr;//只显示标题，而不加载

@property BOOL contenButtonsWidthMax; //是否btn需要一排排满

//是否显示有箭头
//- (id)initWithShowArrowButton:(BOOL)show;

//显示在父视图控制器
- (void)addParentController;

//直接选择某个索引
- (void)itemDidSelectedWithIndex:(NSInteger)index;

/**
 *  设置位置 不设置就是64
 *
 *  @param frame <#frame description#>
 */
- (void)viewInit:(int)y;

/**
 *  添加views
 *
 *  @param arr views
 */
-(void)setView:(NSMutableArray *)arr;

-(void)viewDid;

@end
