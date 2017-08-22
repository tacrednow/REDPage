//
//  SecondViewController.m
//  REDPage
//
//  Created by rednow on 2017/5/4.
//  Copyright © 2017年 rednow. All rights reserved.
//

#import "SecondViewController.h"

@interface SecondViewController () <UIScrollViewDelegate>

@property(nonatomic, strong)UILabel *label;
@property(nonatomic, strong)UIDynamicAnimator *animator;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:_scrollView];

    _scrollView.contentSize=CGSizeMake(self.view.frame.size.width, 2000);
    _scrollView.delegate=self;
    _label=[[UILabel alloc]initWithFrame:CGRectMake(50, 400, 100, 100)];
    _label.backgroundColor=[UIColor blueColor];
    [_scrollView addSubview:_label];
    UIPanGestureRecognizer *pan=[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panLabel:)];
    _label.userInteractionEnabled=YES;
    [_label addGestureRecognizer:pan];


    
}

//-(void)panLabel:(UIPanGestureRecognizer *)pan{
//    
//    if (pan.state == UIGestureRecognizerStateBegan) {
////        currentOffsety=self.subScrollView.contentOffset.y;
//        //        startPoint = [pan locationInView:self.view];
//        //        currentOffsety = self.contentoffSetY;
//        //        [self.animator removeAllBehaviors];
//    }else if(pan.state == UIGestureRecognizerStateChanged){
//        
//        //        CGPoint changePoint = [pan locationInView:self.view];
//        //        CGFloat delta = startPoint.y - changePoint.y;
//        pan.view.frame = CGRectMake( [pan translationInView:pan.view].x, [pan translationInView:pan.view].y, 100, 100);
//    }else if (pan.state == UIGestureRecognizerStateEnded){
//        
//        UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_label]];
//        itemBehavior.elasticity = 0.9; //弹力
//        itemBehavior.friction = 0.1;     //摩擦力
//        itemBehavior.density = 1;    //密度
//        itemBehavior.resistance = 0.1; // 阻力
//        itemBehavior.allowsRotation = YES; //允许旋转
//        [_animator addBehavior:itemBehavior];
//        
//        // 推动行为
//        UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_label] mode:UIPushBehaviorModeInstantaneous];
//        pushBehavior.pushDirection = CGVectorMake(0, - 2.0);
//        pushBehavior.magnitude = 20.0;
//        [_animator addBehavior:pushBehavior];
//        
//        // 碰撞行为
//        UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_label]];
//        //设置碰撞边界为referenceView的边界。
//        collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
//        [_animator addBehavior:collisionBehavior];
//
//    }
//    
//}
//
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    UIDynamicItemBehavior *itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:@[_label]];
//    itemBehavior.elasticity = 0.9; //弹力
//    itemBehavior.friction = 0.1;     //摩擦力
//    itemBehavior.density = 1;    //密度
//    itemBehavior.resistance = 0.1; // 阻力
//    itemBehavior.allowsRotation = YES; //允许旋转
//    [_animator addBehavior:itemBehavior];
//
//    // 推动行为
//    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc] initWithItems:@[_label] mode:UIPushBehaviorModeInstantaneous];
//    pushBehavior.pushDirection = CGVectorMake(0, - 2.0);
//    pushBehavior.magnitude = 40.0;
//    [_animator addBehavior:pushBehavior];
//    
//    // 碰撞行为
//    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[_label]];
//    //设置碰撞边界为referenceView的边界。
//    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
//    [_animator addBehavior:collisionBehavior];
//
//}
//
//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    [self.animator removeAllBehaviors];
//    _label.frame=CGRectMake(50, 400, 100, 100);
//
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
////    scrollView.panGestureRecognizer
//    NSLog(@"TEST:%f",scrollView.bounds.origin.y);
////    NSLog(@"panGestureRecognizer:%@",scrollView.panGestureRecognizer);
////    NSLog(@"pinchGestureRecognizer:%@",scrollView.pinchGestureRecognizer);
//}

@end
