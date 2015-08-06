//
//  JTNavTabBar.h
//  TestApp
//
//  Created by 胡雄恩 on 15/6/9.
//  Copyright (c) 2015年 胡雄恩. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JTNavTabBarDelegate <NSObject>
@optional

- (void)itemDidSelectedWithIndex:(NSInteger)index;

- (void)shouldPopNavgationItemMenu:(BOOL)pop height:(CGFloat)height;

@end

@interface JTNavTabBar : UIView

@property (nonatomic, weak)     id          <JTNavTabBarDelegate>delegate;

@property (nonatomic, assign)   NSInteger   currentItemIndex;           // current selected item's index
@property (nonatomic, strong)   NSArray     *itemTitles;                // all items' title

@property (nonatomic, strong)   UIColor     *lineColor;                 // set the underscore color

@property BOOL contenButtonsWidthMax;//是否需要一排放满btn

- (id)initWithFrame:(CGRect)frame showArrowButton:(BOOL)show;

- (void)updateData;

@end
