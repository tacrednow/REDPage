//
//  REDTabBarController.m
//  sxsiosapp
//
//  Created by rednow on 15/10/15.
//  Copyright © 2015年 mshare. All rights reserved.
//

#import "REDTabBarController.h"
#import "dynamicItem.h"

#define titleScrollViewHeight  44

@interface REDTabBarController ()
@property (nonatomic, strong) NSMutableArray *titleLabelArray;
@property (nonatomic, strong) NSMutableArray *viewControllerFlag;
@property (nonatomic, strong) NSMutableArray *controllerArray;
@property (nonatomic, strong) NSMutableArray *controllerArrayAll;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic) CGFloat contentOffsetY;
@property (nonatomic) CGFloat oldContentOffsetY;
@property (nonatomic) BOOL scrollViewChange;
@property (nonatomic, strong) UIPanGestureRecognizer *bannerPan;

@end

@implementation REDTabBarController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.titleArray=[[NSMutableArray alloc]init];
        self.controllerArray=[[NSMutableArray alloc]init];
        self.controllerArrayAll=[[NSMutableArray alloc]init];
        self.titleLabelArray=[[NSMutableArray alloc]init];
        self.viewControllerFlag=[[NSMutableArray alloc]init];
        self.mostBufferPageCount=10;
        _titleLineWidth=20;
        _titleTopEdge=10;
        _titleLeftRightEdge=15;
        _titleWidthRate=2;
        _scrollViewChange=YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.tabBarType >= REDTabBarTypePage && self.titleArray.count>0) {
        if (self.pageType <= REDPageTypeOne) {
            for (int i=0 ; i<self.titleArray.count ; i++) {
                [self.viewControllerFlag addObject:@0];
                [self.controllerArrayAll addObject:@{@"vc":@""}];
            }
            [self gotoCurrectScrollView];
        }else{
            if (self.titleArray.count!=self.viewControllers.count) {
                [self.titleArray removeAllObjects];
                for (UIViewController *viewController in self.viewControllers) {
                    if (viewController.title) {
                        [self.titleArray addObject:viewController.title];
                    }else{
                        [self.titleArray addObject:@"title"];
                    }
                }
            }
            for (int i=0 ; i<self.titleArray.count ; i++) {
                [self.viewControllerFlag addObject:@0];
                [self.controllerArrayAll addObject:@{@"vc":@""}];
            }
            [self gotoCurrectScrollView];
        }
        [self.view insertSubview:self.scrollView belowSubview:self.tabBar];
        self.tabBar.hidden=YES;
        if (self.tabBarType == REDTabBarTypePageBanner) {
            
            [self.view addSubview:self.banner];
            [self.banner addSubview:self.titleScrollView];
            self.titleScrollView.frame=CGRectMake(0, self.banner.frame.size.height-self.titleScrollView.frame.size.height, self.titleScrollView.frame.size.width, self.titleScrollView.frame.size.height);
            [self.banner addSubview:self.statusView];
        }else{
            self.navigationItem.titleView=self.titleScrollView;
        }
    }
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
//        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
//    }
//}

-(void)dealloc{
    if (self.tabBarType == REDTabBarTypePageBanner) {
        for (int i=0; i<self.controllerArray.count; i++) {
            NSDictionary *dict=self.controllerArray[i];
            UIViewController *viewController=dict[@"controller"];
            
            for (UIView *subview in viewController.view.subviews){
                if ([NSStringFromClass(subview.superclass) isEqualToString:@"UIScrollView"]){
                    [subview removeObserver:self forKeyPath:@"contentOffset"];
                }
            }

//            if ([NSStringFromClass(viewController.view.superclass) isEqualToString:@"UIScrollView"]) {
//                [viewController.view removeObserver:self forKeyPath:@"contentOffset"];
//            }
        }
    }
}

-(void)setSelectedViewController:(__kindof UIViewController *)selectedViewController{
    if (self.tabBarType == REDTabBarTypeDefault) {
        [super setSelectedViewController:selectedViewController];
    }
//    else if (self.tabBarType >= REDTabBarTypePage) {
//        if (self.pageType == REDPageTypeCodeMore || self.pageType == REDPageTypeMore) {
//            [self addPageView:selectedViewController];
//            NSUInteger index=[self.viewControllers indexOfObject:selectedViewController];
//            [UIView animateWithDuration:0.3 animations:^{
//                self.scrollView.contentOffset=CGPointMake(self.view.frame.size.width * index, 0);
//            }];
//        }
//    }
}

#pragma mark - UIScrollViewDelegate

//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [self gotoCurrectScrollView];
//}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView && scrollView.contentOffset.x!=0) {
        int index=scrollView.contentOffset.x / self.view.frame.size.width;
        
        //判断page是否变化，是否需要刷新页面.
        int indexChange=(int)((scrollView.contentOffset.x / self.view.frame.size.width)*10) % 10;
        if (indexChange==0) {
            _scrollViewChange=NO;
            self.index = index;
            [self gotoCurrectScrollView];
        }
        
        UILabel *labelFront=self.titleLabelArray[index];
        UILabel *labelBack;
        if (index<self.titleLabelArray.count-1 && scrollView.contentOffset.x > 0) {
            labelBack=self.titleLabelArray[index+1];
        }else{
            labelBack=labelFront;
        }
        float distance=CGRectGetMidX(labelBack.frame)-CGRectGetMidX(labelFront.frame);
        float rate=distance/self.view.frame.size.width;
        float rateWidth = (1 + _titleWidthRate * fabs(sin(scrollView.contentOffset.x * (M_PI / self.view.frame.size.width))));
        self.titleLine.frame=CGRectMake(labelFront.center.x-(_titleLineWidth/2 * rateWidth) + ( scrollView.contentOffset.x - self.view.frame.size.width * index ) * rate, self.titleLine.frame.origin.y, _titleLineWidth * rateWidth, self.titleLine.frame.size.height);
        
        CGFloat ur, ug, ub, ua;
        CGFloat r, g, b, a;
        float rateColor = ((int)scrollView.contentOffset.x % (int)self.view.frame.size.width) / self.view.frame.size.width;
        [self.unselectedTitle.textColor getRed:&ur green:&ug blue:&ub alpha:&ua];
        [self.selectedTitle.textColor getRed:&r green:&g blue:&b alpha:&a];
        
        labelBack.textColor=[UIColor colorWithRed:ur+(r-ur)*rateColor green:ug+(g-ug)*rateColor blue:ub+(b-ub)*rateColor alpha:ua+(a-ua)*rateColor];
        labelFront.textColor=[UIColor colorWithRed:r+(ur-r)*rateColor green:g+(ug-g)*rateColor blue:b+(ub-b)*rateColor alpha:a+(ua-a)*rateColor];
    }
}

//- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    if (scrollView==self.scrollView) {
//        self.index = (int) (targetContentOffset->x / self.view.frame.size.width);
//        [self gotoCurrectScrollView];
//    }else if (scrollView==self.titleScrollView){
//        
//    }
//}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    if (scrollView==self.scrollView) {
        return NO;
    }
    return YES;
}

#pragma mark - Setter

-(UIView *)statusView{
    if (!_statusView) {
        self.statusView=[[UIView alloc]initWithFrame:CGRectMake(0, -64, self.view.bounds.size.width, 64)];
        if (self.pageUIType & REDPageUITitleBlur) {
            self.statusView.backgroundColor=[UIColor clearColor];
            UIBlurEffect *blur=[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
            UIVisualEffectView *visual=[[UIVisualEffectView alloc]initWithEffect:blur];
            visual.frame=self.statusView.bounds;
            [self.statusView addSubview:visual];
        }else{
            self.statusView.backgroundColor=[UIColor whiteColor];
        }
        self.statusView.hidden=NO;
    }
    return _statusView;
}

-(UILabel *)unselectedTitle{
    if (!_unselectedTitle) {
        self.unselectedTitle=[[UILabel alloc]init];
        self.unselectedTitle.textColor=[UIColor lightGrayColor];
        self.unselectedTitle.font=[UIFont systemFontOfSize:16];
    }
    return _unselectedTitle;
}

-(UILabel *)selectedTitle{
    if (!_selectedTitle) {
        self.selectedTitle=[[UILabel alloc]init];
        self.selectedTitle.textColor=[UIColor blackColor];
        self.selectedTitle.font=[UIFont systemFontOfSize:16];
    }
    return _selectedTitle;
}

-(UIImageView *)titleLine{
    if (!_titleLine) {
        self.titleLine=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, _titleLineWidth, 2)];
        self.titleLine.backgroundColor=self.selectedTitle.textColor;
        self.titleLine.clipsToBounds=YES;
    }
    return _titleLine;
}

-(UIScrollView *)titleScrollView{
    if (!_titleScrollView) {
        self.titleScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, titleScrollViewHeight)];
        self.titleScrollView.delegate=self;
        self.titleScrollView.showsHorizontalScrollIndicator=NO;
        if (self.pageUIType & REDPageUITitleBlur) {
            self.titleScrollView.backgroundColor=[UIColor clearColor];
            if (_tabBarType==REDTabBarTypePageBanner) {
                UIBlurEffect *blur=[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
                UIVisualEffectView *visual=[[UIVisualEffectView alloc]initWithEffect:blur];
                visual.frame=self.titleScrollView.bounds;
                [self.titleScrollView addSubview:visual];
            }
        }else{
            self.titleScrollView.backgroundColor=[UIColor whiteColor];
        }
        NSMutableArray *titleArray=[NSMutableArray new];
        CGRect frame=CGRectZero;
        for (int i=0; i<self.titleArray.count; i++) {
            UILabel *title;
            if (_index==i) {
                title =  [self titleLabelCopy:self.selectedTitle];
            }else{
                title =  [self titleLabelCopy:self.unselectedTitle];
            }
            title.frame=CGRectMake(CGRectGetMaxX(frame), _titleTopEdge, frame.size.width, frame.size.height);
            title.text=self.titleArray[i];
            title.textAlignment=NSTextAlignmentCenter;
            [title sizeToFit];
            title.frame=CGRectMake(title.frame.origin.x, _titleTopEdge, title.frame.size.width+_titleLeftRightEdge, title.frame.size.height+5);
            
            [self.titleScrollView addSubview:title];
            frame=title.frame;
            
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tiltePressed:)];
            title.userInteractionEnabled=YES;
            [title addGestureRecognizer:tap];
            
            [self.titleLabelArray addObject:title];
            [titleArray addObject:title];
            if (_index==i) {
                [self.titleScrollView addSubview:self.titleLine];
                _titleLineWidth=self.titleLine.frame.size.width;
                self.titleLine.frame = CGRectMake(title.center.x - self.titleLine.frame.size.width/2, CGRectGetMaxY(self.titleScrollView.frame)-self.titleLine.frame.size.height-_titleLineBottomEdge, _titleLineWidth, self.titleLine.frame.size.height);
            }
        }
        self.titleScrollView.contentSize=CGSizeMake(CGRectGetMaxX(frame), titleScrollViewHeight);
        
        if (CGRectGetMaxX(frame) < self.view.frame.size.width) {
            if (self.pageUIType & REDPageUITitleCenter) {
                float rate=self.view.frame.size.width/CGRectGetMaxX(frame);
                frame=CGRectZero;
                for (int i=0; i<titleArray.count; i++) {
                    UILabel *title=titleArray[i];
                    title.frame=CGRectMake(CGRectGetMaxX(frame), _titleTopEdge, title.frame.size.width * rate, title.frame.size.height);
                    frame=title.frame;
                    if (_index==i) {
                        self.titleLine.frame = CGRectMake(title.center.x - self.titleLine.frame.size.width/2, CGRectGetMaxY(self.titleScrollView.frame)-self.titleLine.frame.size.height-_titleLineBottomEdge, _titleLineWidth, self.titleLine.frame.size.height);
                    }
                }
            }
            self.titleScrollView.frame=CGRectMake(0, 0, CGRectGetMaxX(frame), titleScrollViewHeight);
        }
    }
    return _titleScrollView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        self.scrollView=[[UIScrollView alloc] initWithFrame:self.view.bounds];
        self.scrollView.backgroundColor=[UIColor clearColor];
        self.scrollView.pagingEnabled=YES;
        self.scrollView.delegate=self;
        self.scrollView.contentSize=CGSizeMake(self.view.frame.size.width * self.titleArray.count, self.view.frame.size.height);
        self.scrollView.showsHorizontalScrollIndicator=NO;
        if (self.pageUIType & REDPageHorizontalForbid) {
            self.scrollView.scrollEnabled=NO;
        }
    }
    return _scrollView;
}

-(UIView *)banner{
    if (!_banner) {
        self.banner=[[REDView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, _bannerHeight)];
        self.banner.backgroundColor=[UIColor clearColor];
        _bannerPan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panBanner:)];
        [self.banner addGestureRecognizer:_bannerPan];
    }
    return _banner;
}

#pragma mark - ButtonAction

-(void)removeAllPageAndResetCurrectPage{
    
    while (self.controllerArray.count>0) {
        NSDictionary *dict=self.controllerArray.firstObject;
        UIViewController *viewController=dict[@"controller"];
        [self.viewControllerFlag replaceObjectAtIndex:[dict[@"index"] intValue] withObject:@0];
        [viewController removeFromParentViewController];
        [self.controllerArray removeObjectAtIndex:0];
        [viewController.view removeFromSuperview];
        viewController=nil;
    }
    [self gotoCurrectScrollView];
}

-(void)gotoPageViewWithIndex:(NSInteger)index{
    self.index=(int)index;
    [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width * index, 0) animated:NO];
    [self gotoCurrectScrollView];
}

//显示当前page页
-(void)gotoCurrectScrollView{
//    if (self.pageType <= REDPageTypeOne) {
        UIViewController *viewController;
    self.pageViewController=viewController;
        if ([self.viewControllerFlag[self.index] intValue] == 0) {
            if (self.pageType <= REDPageTypeOne) {
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:_storyboardName bundle:nil];
                viewController=[storyboard instantiateViewControllerWithIdentifier:_pageIdentifier];
                
                viewController.title=self.titleArray[self.index];
                viewController.view.frame=CGRectMake(self.view.frame.size.width * self.index, 0, self.view.frame.size.width, self.view.frame.size.height);
                [self addChildViewController:viewController];
                [self.scrollView addSubview:viewController.view];
            }else{
                viewController=self.viewControllers[self.index];
                [self addPageView:viewController];

                //复制storyboard中的viewController会丢失对象，不能使用。
//                NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:self.pageViewController];
//                viewController = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
            }
            
            if (self.tabBarType == REDTabBarTypePageBanner) {
                [self bannerContent:viewController];
            }
            
            [self.controllerArrayAll replaceObjectAtIndex:self.index withObject:@{@"vc":viewController}];

            [self.controllerArray addObject:@{@"index":@(self.index), @"controller":viewController}];
            [self.viewControllerFlag replaceObjectAtIndex:self.index withObject:@1];
            
            if (self.controllerArray.count > self.mostBufferPageCount) {
                NSDictionary *dict=self.controllerArray.firstObject;
                UIViewController *viewController=dict[@"controller"];
                if (self.tabBarType == REDTabBarTypePageBanner) {
                    [viewController.view removeObserver:self forKeyPath:@"contentOffset"];
                }
                [self.viewControllerFlag replaceObjectAtIndex:[dict[@"index"] intValue] withObject:@0];
                [self.controllerArrayAll replaceObjectAtIndex:[dict[@"index"] intValue] withObject:@{@"vc":@""}];
                [viewController removeFromParentViewController];
                [self.controllerArray removeObjectAtIndex:0];
                [viewController.view removeFromSuperview];
                viewController=nil;
            }
        }else{
            NSDictionary *dict=self.controllerArrayAll[self.index];
            viewController=dict[@"vc"];
            if (self.tabBarType == REDTabBarTypePageBanner) {
                [self bannerContent:viewController];
            }
        }
    
    self.pageViewController=viewController;
//    }
//else{
//        UIViewController *viewController=self.viewControllers[self.index];
//        [self addPageView:viewController];
//        if (self.tabBarType == REDTabBarTypePageBanner) {
//            [self bannerContent:viewController];
//        }
//        
//    }

    //替换title
    CGRect frame=CGRectZero;
    for (int i=0; i<self.titleLabelArray.count; i++) {
        UILabel *label=self.titleLabelArray[i];
        
        UILabel *labelNew;
        if (_index==i) {
            labelNew =  [self titleLabelCopy:self.selectedTitle];
        }else{
            labelNew =  [self titleLabelCopy:self.unselectedTitle];
        }

        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tiltePressed:)];
        labelNew.userInteractionEnabled=YES;
        [labelNew addGestureRecognizer:tap];
        
        labelNew.text=label.text;
        labelNew.textAlignment=NSTextAlignmentCenter;
        labelNew.frame=CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, label.frame.size.height);
        [self.titleLabelArray replaceObjectAtIndex:i withObject:labelNew];
        frame=labelNew.frame;
        [label.superview addSubview:labelNew];
        [label removeFromSuperview];

        //titleScrollView自动正确位移
        if (_index==i) {
            if (CGRectGetMinX(label.frame)<self.titleScrollView.contentOffset.x) {
                [UIView animateWithDuration:0.3 animations:^{
                    self.titleScrollView.contentOffset=CGPointMake(CGRectGetMinX(label.frame), 0);
                }];
            }else if (CGRectGetMaxX(label.frame)>(self.titleScrollView.contentOffset.x+self.titleScrollView.frame.size.width)){
                [UIView animateWithDuration:0.3 animations:^{
                    self.titleScrollView.contentOffset=CGPointMake(CGRectGetMinX(label.frame)+label.frame.size.width-self.titleScrollView.frame.size.width, 0);
                }];
            }
        }
    }
}

//设置banner的外观和内容
-(void)bannerContent:(UIViewController *)viewController{
    [self.view bringSubviewToFront:self.banner];
//    self.navigationController.navigationBarHidden=NO;

    BOOL isScollView=NO;
    if ([NSStringFromClass([viewController.view.superclass class]) isEqualToString:@"UIScrollView"] || [NSStringFromClass([viewController.view class]) isEqualToString:@"UIScrollView"]) {
        self.subScrollView=(UIScrollView *)viewController.view;
        isScollView=YES;
    }else{
        for (UIView *subview in viewController.view.subviews){
            if ([NSStringFromClass(subview.superclass) isEqualToString:@"UIScrollView"] || [NSStringFromClass(subview.class) isEqualToString:@"UIScrollView"]){
                self.subScrollView=(UIScrollView *)subview;
                isScollView=YES;
            }
        }
    }
    if (isScollView) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.subScrollView];
        self.subScrollView.contentInset=UIEdgeInsetsMake(_bannerHeight, 0, 0, 0);
        self.subScrollView.scrollIndicatorInsets=UIEdgeInsetsMake(_bannerHeight, 0, 49, 0);
        NSDictionary *dict=self.controllerArrayAll[self.index];
        CGFloat otherHeight=64 + titleScrollViewHeight;
        if (self.navigationController.navigationBarHidden) {
            otherHeight= 20 + titleScrollViewHeight;
        }
        
        if (self.banner.frame.origin.y>(otherHeight-_bannerHeight)) {
            self.subScrollView.contentOffset=CGPointMake(0, -self.banner.frame.origin.y-_bannerHeight);
        }else{
            if (-otherHeight>self.subScrollView.contentOffset.y) {
                self.subScrollView.contentOffset=CGPointMake(0, -otherHeight);
            }
        }
        if ([NSStringFromClass([dict[@"vc"] class]) isEqualToString:@"__NSCFConstantString"]) {
            [self.subScrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
            if (self.banner.frame.origin.y<=(otherHeight-_bannerHeight)) {
                self.subScrollView.contentOffset=CGPointMake(0, -otherHeight);
            }
        }
    }
}

-(void)tiltePressed:(UITapGestureRecognizer *)tap{
    for (int i=0; i<self.titleLabelArray.count; i++) {
        UILabel *label=self.titleLabelArray[i];
        if ([label isEqual:tap.view]) {
            self.index=i;
            _scrollViewChange=YES;
            [self.scrollView setContentOffset:CGPointMake(self.view.frame.size.width * i, 0) animated:YES];
            [self gotoCurrectScrollView];
        }
    }
}

-(void)addPageView:(UIViewController *)viewController{
    if (![viewController.view.superview isEqual:self.scrollView]) {
        NSUInteger index=[self.viewControllers indexOfObject:viewController];
        viewController.view.frame=CGRectMake(self.view.frame.size.width * index, 0, self.view.frame.size.width, self.view.frame.size.height);
        [self.scrollView addSubview:viewController.view];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    CGFloat otherHeight =64 +  titleScrollViewHeight;
    self.statusView.hidden=YES;
    if (self.navigationController.navigationBarHidden) {
        otherHeight= 20 + titleScrollViewHeight;
        self.statusView.hidden=NO;
    }
    CGFloat contentOffsetY = self.subScrollView.contentOffset.y + otherHeight;

    self.subScrollView.scrollIndicatorInsets=UIEdgeInsetsMake(-contentOffsetY+110, 0, 49, 0);
    if (contentOffsetY < 0) {
        self.banner.frame=CGRectMake(0, -_bannerHeight - self.subScrollView.contentOffset.y, self.view.bounds.size.width, _bannerHeight);
        self.titleScrollView.frame=CGRectMake(0, self.banner.frame.size.height-self.titleScrollView.frame.size.height, self.titleScrollView.frame.size.width, self.titleScrollView.frame.size.height);
        if (self.pageUIType & REDPageUINavClear) {
            UIImage *image=[UIImage imageNamed:@"透明.png"];
            [self.navigationController.navigationBar setShadowImage:[UIImage new]];
            [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setTranslucent:YES];
        }
        if (otherHeight - _bannerHeight > contentOffsetY) {
            self.banner.frame=CGRectMake(0,  0, self.view.bounds.size.width, _bannerHeight);
            self.titleScrollView.frame=CGRectMake(0, self.banner.frame.size.height-self.titleScrollView.frame.size.height , self.titleScrollView.frame.size.width, self.titleScrollView.frame.size.height);
        }
    }else{
        self.banner.frame=CGRectMake(0, -_bannerHeight + otherHeight, self.view.bounds.size.width, _bannerHeight);
        self.titleScrollView.frame=CGRectMake(0, self.banner.frame.size.height-self.titleScrollView.frame.size.height , self.titleScrollView.frame.size.width, self.titleScrollView.frame.size.height);
        self.statusView.frame=CGRectMake(0, self.banner.frame.size.height-self.titleScrollView.frame.size.height-64, self.view.bounds.size.width, 64);
        if (self.pageUIType & REDPageUINavClear) {
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setTranslucent:YES];
        }
    }
//    _oldContentOffsetY=self.subScrollView.contentOffset.y;
}

-(void)panBanner:(UIPanGestureRecognizer *)pan{
    static CGFloat translationSetY;
    static CGFloat locationSetY;
    static CGFloat currentOffsety;
    static BOOL locationFirst;
    static CGFloat oldOffsetY;
    static CGFloat subScrollViewPanY;
    if (pan.state == UIGestureRecognizerStateBegan) {
        currentOffsety=self.subScrollView.contentOffset.y;
        [self.animator removeAllBehaviors];
        locationSetY=[pan locationInView:pan.view].y;
        translationSetY=[pan translationInView:pan.view].y;
        subScrollViewPanY=[self.subScrollView.panGestureRecognizer translationInView:self.subScrollView].y;
    }else if(pan.state == UIGestureRecognizerStateChanged){
        if (pan.numberOfTouches==1) {
            if (pan.view.frame.origin.y>0 && [pan translationInView:pan.view].y>0) {
                [pan setTranslation:CGPointMake(0, translationSetY + ([pan locationInView:pan.view].y-locationSetY) /2) inView:pan.view];
                oldOffsetY=[pan locationInView:pan.view].y;
            }else{
                translationSetY=[pan translationInView:pan.view].y;
            }
            locationFirst=YES;
            self.subScrollView.contentOffset = CGPointMake(0, - [pan translationInView:pan.view].y + currentOffsety);
        }else if (pan.numberOfTouches>=2){
            if (locationFirst) {
                locationFirst=NO;
                locationSetY=[pan locationInView:pan.view].y-oldOffsetY+locationSetY;
            }
            if ([pan translationInView:pan.view].y>0) {
                [pan setTranslation:CGPointMake(0, ([pan locationInView:pan.view].y-locationSetY) /2) inView:pan.view];
                oldOffsetY=[pan locationInView:pan.view].y;
            }
            self.subScrollView.contentOffset = CGPointMake(0, - [pan translationInView:pan.view].y + currentOffsety);
        }
    }else if (pan.state == UIGestureRecognizerStateEnded){
        
        CGFloat speed = [pan velocityInView:self.view].y;
        dynamicItem * item = [dynamicItem new];
        
        item.center=CGPointMake(0, pan.view.center.y);
        
        UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[item]];
        [itemBehavior addLinearVelocity:CGPointMake(0, speed) forItem:item];
        itemBehavior.resistance = 2.0;
        [_animator addBehavior:itemBehavior];

        itemBehavior.action = ^(){
            if (self.subScrollView.panGestureRecognizer.state == UIGestureRecognizerStateChanged || [self.subScrollView.panGestureRecognizer translationInView:self.subScrollView].y!=subScrollViewPanY) {
                [self.animator removeAllBehaviors];
                return;
            }else if ([pan translationInView:self.banner].y!=translationSetY){
                if (self.subScrollView.contentOffset.y < -_bannerHeight) {
                    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        self.subScrollView.contentOffset=CGPointMake(0, -_bannerHeight);
                    } completion:^(BOOL finished) {
                        
                    }];
                }
                [self.animator removeAllBehaviors];
                return;
            }
            
            if (self.subScrollView.contentOffset.y < -_bannerHeight) {
                [self.animator removeAllBehaviors];
                [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.subScrollView.contentOffset=CGPointMake(0, -_bannerHeight);
                } completion:^(BOOL finished) {
                    
                }];
            }else if (self.subScrollView.contentOffset.y+self.subScrollView.bounds.size.height<self.subScrollView.contentSize.height+100) {
                self.subScrollView.contentOffset = CGPointMake(0, -item.center.y-_bannerHeight/2);
            }else{
                [self.animator removeAllBehaviors];
                [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.subScrollView.contentOffset=CGPointMake(0, self.subScrollView.contentSize.height-self.subScrollView.bounds.size.height);
                } completion:^(BOOL finished) {
                    
                }];
            }
        };
    }
}

#pragma mark - tool method

-(UILabel *)titleLabelCopy:(UILabel *)oldLabel{
    UILabel *newLabel;
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:oldLabel];
    newLabel = [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
    newLabel.clipsToBounds=YES;
    newLabel.layer.cornerRadius=oldLabel.layer.cornerRadius;
    newLabel.layer.borderWidth=oldLabel.layer.borderWidth;
    newLabel.layer.borderColor=oldLabel.layer.borderColor;
    return newLabel;
}

@end
