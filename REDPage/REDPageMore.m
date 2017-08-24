//
//  REDPageMore.m
//  REDPage
//
//  Created by rednow on 2017/8/24.
//  Copyright © 2017年 rednow. All rights reserved.
//

#import "REDPageMore.h"

@interface REDPageMore ()

@end

@implementation REDPageMore

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.tabBarType=REDTabBarTypePage;
        self.pageType=REDPageTypeMore;
        self.pageUIType=REDPageUITitleBlur;
        self.mostBufferPageCount=5;
        self.titleWidthRate=2;
//        self.bannerHeight=210;
        
        self.unselectedTitle=[[UILabel alloc]init];
        self.unselectedTitle.textColor=[UIColor lightGrayColor];
        self.unselectedTitle.font=[UIFont systemFontOfSize:17];
        
        self.selectedTitle=[[UILabel alloc]init];
        self.selectedTitle.textColor=[UIColor blackColor];
        self.selectedTitle.font=[UIFont boldSystemFontOfSize:17];
        [self.titleArray addObjectsFromArray:@[@"page1", @"page2"]];
        
        self.titleLineBottomEdge=0;
        self.titleTopEdge=9;
        
    }
    return self;
}

@end
