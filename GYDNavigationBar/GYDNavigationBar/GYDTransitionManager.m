//
//  GYDTransitionManger.m
//  GYDNavBarDemo
//
//  Created by 贵永冬 on 2017/3/13.
//  Copyright © 2017年 贵永冬. All rights reserved.
//

#import "GYDTransitionManager.h"
#import "UIViewController+GYDNav.h"

@interface GYDTransitionManager ()<UIViewControllerAnimatedTransitioning>

/**
 弱引用导航控制器 在转场动画进行完后 重置转场动画的代理
 */
@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic, assign) UINavigationControllerOperation operation;


@end

@implementation GYDTransitionManager




#pragma mark - UINavigationControllerDelegate


- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    self.operation = operation;
    self.navigationController = navigationController;
    return self;
}

#pragma mark -UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView  *containerView = [transitionContext containerView];
    if (!containerView) {
        [transitionContext completeTransition:YES];
        return;
    }
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *fromView, *toView;
    if ([transitionContext respondsToSelector:@selector(viewForKey:)]) {
        fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    }else {
        fromView = fromViewController.view;
        toView = toViewController.view;
    }
    if (self.operation == UINavigationControllerOperationPush) {
        CGRect fromViewFrame = [transitionContext initialFrameForViewController:fromViewController];
        fromView.frame = fromViewFrame;
        fromViewFrame.origin.x = -fromViewFrame.size.width;
        CGRect toViewFinalFrame = [transitionContext finalFrameForViewController:toViewController];
        toViewFinalFrame.origin.x = fromView.frame.size.width;
        toView.frame = toViewFinalFrame;
        toViewFinalFrame.origin.x = 0;
        
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toView.frame = toViewFinalFrame;
            fromView.frame = fromViewFrame;
            [fromViewController.navigationController d_setNavigationBarAlpha:self.toAlpha];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            if (finished) {
                self.navigationController.delegate = nil;
            }
        }];
    }else if (self.operation == UINavigationControllerOperationPop) {
        CGRect fromViewFrame = [transitionContext initialFrameForViewController:fromViewController];
        fromViewFrame.origin.x = fromViewFrame.size.width;
        
        CGRect toViewFrame = [transitionContext finalFrameForViewController:toViewController];
        toViewFrame.origin.x = -toViewFrame.size.width;
        toView.frame = toViewFrame;
        toViewFrame.origin.x = 0;
        
        //4. 添加到上下文的view上
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
        
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            toView.frame = toViewFrame;
            fromView.frame = fromViewFrame;
            [fromViewController.navigationController d_setNavigationBarAlpha:self.toAlpha];
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
            if (finished) {
                self.navigationController.delegate = nil;
            }
        }];
    }
}


@end




