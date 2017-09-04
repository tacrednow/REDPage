//
//  REDTabBarController.h
//  sxsiosapp
//
//  Created by rednow on 15/10/15.
//  Copyright © 2015年 mshare. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REDView.h"

typedef NS_ENUM(NSInteger, REDTabBarType) {
    REDTabBarTypeDefault,
    REDTabBarTypePage,
    REDTabBarTypePageBanner
};

typedef NS_ENUM(NSInteger, REDPageType) {
    REDPageTypeCodeOne,                    //一个类对应多个页面 code方式
    REDPageTypeOne,                        //一个类对应多个页面 StoryBoard方式
    REDPageTypeCodeMore,                   //多个类对应多个页面 code方式
    REDPageTypeMore                        //多个类对应多个页面 StoryBoard方式，如同UITabbarView一样使用
};

typedef NS_ENUM(NSInteger, REDPageUIType) {
    REDPageUIDefault             = 0,
    REDPageUITitleCenter         = 1 << 0,
    REDPageUITitleBlur           = 1 << 1,
    REDPageUINavClear            = 1 << 2,
    REDPageHorizontalForbid      = 1 << 3,
};

@interface REDTabBarController : UITabBarController <UIScrollViewDelegate, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIScrollView *listScrollView;
@property (nonatomic, strong) UIScrollView *titleScrollView;
@property (nonatomic) int page;
@property (nonatomic, strong) NSMutableArray *titleArray;

/**
 *  tabbar类型
 */
@property(nonatomic)REDTabBarType tabBarType;

/**
 *  page类型
 */
@property(nonatomic)REDPageType pageType;
@property(nonatomic)REDPageUIType pageUIType;

@property(nonatomic, strong)NSString *storyboardName;
@property(nonatomic, strong)NSString *pageIdentifier;
@property (nonatomic) int mostBufferPageCount;
@property (nonatomic, strong)UIViewController *pageViewController;

@property (nonatomic, strong)UILabel *selectedTitle;
@property (nonatomic, strong)UILabel *unselectedTitle;
@property (nonatomic) float titleLeftRightEdge;
@property (nonatomic) float titleTopEdge;
@property (nonatomic, strong)UIImageView *titleLine;
@property (nonatomic) float titleLineWidth;
@property (nonatomic) float titleLineBottomEdge;
@property (nonatomic) int titleWidthRate;

/**
 *  banner高度
 */
@property (nonatomic) float bannerHeight;

/**
 *  banner View
 */
@property (nonatomic, strong) REDView *banner;
@property (nonatomic, strong) UIScrollView *subScrollView;
@property (nonatomic, strong) UIView *statusView;

-(void)tiltePressed:(UITapGestureRecognizer *)tap;
-(void)gotoPageViewWithIndex:(NSInteger)index;
-(void)removeAllPageAndResetCurrectPage;

@end
