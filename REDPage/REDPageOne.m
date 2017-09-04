//
//  REDPageOne.m
//  REDPage
//
//  Created by rednow on 2017/5/4.
//  Copyright © 2017年 rednow. All rights reserved.
//

#import "REDPageOne.h"

@interface REDPageOne ()
@property (strong, nonatomic) IBOutlet UIView *bannerView;

@end

@implementation REDPageOne

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tabBarType=REDTabBarTypePageBanner;
        self.pageType=REDPageTypeOne;
        self.pageUIType=REDPageUITitleCenter | REDPageUINavClear;
        self.mostBufferPageCount=5;
        self.titleWidthRate=2;
        self.bannerHeight=210;
        
        self.unselectedTitle=[[UILabel alloc]init];
        self.unselectedTitle.textColor=[UIColor lightGrayColor];
        self.unselectedTitle.font=[UIFont systemFontOfSize:17];
        
        self.selectedTitle=[[UILabel alloc]init];
        self.selectedTitle.textColor=[UIColor blackColor];
        self.selectedTitle.font=[UIFont boldSystemFontOfSize:17];
        [self.titleArray addObjectsFromArray:@[@"page1", @"page2", @"page3", @"page4", @"page5"]];
        
        self.titleLineBottomEdge=0;
        self.titleTopEdge=9;
        
        self.pageIdentifier=@"PageOne";
        self.storyboardName=@"Main";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _bannerView.frame=CGRectMake(0, 0, self.view.frame.size.width, 166);
    [self.banner addSubview:_bannerView];

//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTranslucent:YES];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
//    UIImage *image=[UIImage imageNamed:@"透明.png"];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
//    [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setTranslucent:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
