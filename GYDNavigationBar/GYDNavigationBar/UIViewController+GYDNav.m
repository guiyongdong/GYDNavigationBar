//
//  UIViewController+GYDNav.m
//  GYDNavBarDemo
//
//  Created by 贵永冬 on 2017/3/13.
//  Copyright © 2017年 贵永冬. All rights reserved.
//

#import "UIViewController+GYDNav.h"
#import <objc/runtime.h>
#import "GYDTransitionManager.h"


static const void *D_NavBarAlpha;
static const void *D_TransitionEnable;
static const void *D_TransitionManger;
static const void *D_FullScreenEnable;
static const void *D_BarBackgroundView;
static const void *D_ShadowView;
static const void *D_PanGesturePop;

#define GYD_IOS10Later ([[[UIDevice currentDevice] systemVersion] floatValue] >=10.0)

@interface UINavigationController ()

@property (nonatomic, strong) GYDTransitionManager *transitionManager;

@property (nonatomic, strong) UIView *barBackgroundView;

@property (nonatomic, strong) UIView *shadowView;


/**
 是否是pan手势侧滑返回引发的pop 默认NO
 */
@property (nonatomic, assign) BOOL isPanGesturePop;


@end

@implementation UINavigationController (GYDNav)

#pragma mark - swizzleding

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzledingPop];
        [self swizzledingUpdateInteractiveTransition];
        [self swizzledViewDidLoad];
    });
}


+ (void)swizzledingPop {
    SEL originalPopSelector = @selector(popViewControllerAnimated:);
    SEL swizzledPopSelector = @selector(d_popViewControllerAnimated:);
    Method originalPopMethod = class_getInstanceMethod([self class], originalPopSelector);
    Method swizzledPopMethod = class_getInstanceMethod([self class], swizzledPopSelector);
    BOOL didAddMethod = class_addMethod([self class],
                                        originalPopSelector,
                                        method_getImplementation(swizzledPopMethod),
                                        method_getTypeEncoding(swizzledPopMethod));
    if (didAddMethod) {
        class_replaceMethod([self class],
                            swizzledPopSelector,
                            method_getImplementation(originalPopMethod),
                            method_getTypeEncoding(originalPopMethod));
    }else {
        method_exchangeImplementations(originalPopMethod, swizzledPopMethod);
    }
}
+ (void)swizzledingUpdateInteractiveTransition {
    
    SEL originalSelector = NSSelectorFromString(@"_updateInteractiveTransition:");
    SEL swizzledSelector = @selector(d_updateInteractiveTransition:);
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    method_exchangeImplementations(originalMethod, swizzledMethod);
}
+ (void)swizzledViewDidLoad {
    SEL originalSelector = @selector(viewDidLoad);
    SEL swizzledSelector = @selector(d_viewDidLoad);
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    BOOL didAddMethod = class_addMethod([self class],
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod([self class],
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}



#pragma mark - setter/getter
- (GYDTransitionManager *)transitionManager {
    id transitionManager = objc_getAssociatedObject(self, &D_TransitionManger);
    if (!transitionManager) {
        transitionManager = [[GYDTransitionManager alloc] init];
        self.transitionManager = transitionManager;
    }
    return transitionManager;
}

- (void)setTransitionManager:(GYDTransitionManager *)transitionManager {
    if (!transitionManager)return;
    objc_setAssociatedObject(self,&D_TransitionManger,transitionManager,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)barBackgroundView {
    UIView *barBackgroundView  = objc_getAssociatedObject(self, &D_BarBackgroundView);
    if (barBackgroundView == nil) {
        UINavigationBar *navigationBar = self.navigationBar;
        if (!GYD_IOS10Later) {
            id _backgroundView = [navigationBar valueForKey:@"_backgroundView"];
            barBackgroundView = _backgroundView;
        }else {
            id _backgroundView = [navigationBar valueForKey:@"_barBackgroundView"];
            id backgroundEffectView = [_backgroundView valueForKey:@"_backgroundEffectView"];
            barBackgroundView = (UIView *)backgroundEffectView;
        }
        self.barBackgroundView = barBackgroundView;
    }
    return barBackgroundView;
}

- (void)setBarBackgroundView:(UIView *)barBackgroundView {
    if (!barBackgroundView)return;
    objc_setAssociatedObject(self,&D_BarBackgroundView,barBackgroundView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)shadowView {
    UIView *shadowView = objc_getAssociatedObject(self, &D_ShadowView);
    if (shadowView == nil) {
        if (!GYD_IOS10Later) {
            shadowView = [self.barBackgroundView valueForKey:@"_shadowView"];
        }else {
            id _backgroundView = [self.navigationBar valueForKey:@"_barBackgroundView"];
            shadowView = [_backgroundView valueForKey:@"_shadowView"];
        }
        self.shadowView = shadowView;
    }
    return shadowView;
}
- (void)setShadowView:(UIView *)shadowView {
    if (!shadowView)return;
    objc_setAssociatedObject(self,&D_ShadowView,shadowView,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isPanGesturePop {
    id isPanGesturePop = objc_getAssociatedObject(self, &D_PanGesturePop);
    if (!isPanGesturePop) {
        return NO;
    }
    return [isPanGesturePop boolValue];
}
- (void)setIsPanGesturePop:(BOOL)isPanGesturePop {
    objc_setAssociatedObject(self,&D_PanGesturePop,@(isPanGesturePop),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark - pulic methods
- (void)d_setNavigationBarAlpha:(CGFloat)alpha {
    self.barBackgroundView.alpha = alpha;
    self.shadowView.alpha = alpha;
}


- (void)d_pushViewController:(UIViewController *)viewController fromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha {
    if (fromAlpha == toAlpha) {
        [self pushViewController:viewController animated:YES];
        return;
    }
    GYDTransitionManager *transitionManager = self.transitionManager;
    transitionManager.fromAlpha = fromAlpha;
    transitionManager.toAlpha = toAlpha;
    self.delegate = self.transitionManager;
    [self pushViewController:viewController animated:YES];
}

- (void)d_popViewControllerFromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha {
    GYDTransitionManager *transitionManager = self.transitionManager;
    transitionManager.fromAlpha = fromAlpha;
    transitionManager.toAlpha = toAlpha;
    self.delegate = self.transitionManager;
    [self d_popViewControllerAnimated:YES];
}


#pragma mark privity

- (void)d_popViewControllerAnimated:(BOOL)animated {
    if (self.isPanGesturePop) {
        [self d_popViewControllerAnimated:animated];
        return;
    }
    __weak UIViewController *fromViewContrller = self.topViewController;
    BOOL d_transitionEnable = fromViewContrller.d_transitionEnable;
    if (!d_transitionEnable) {
        [self d_popViewControllerAnimated:animated];
        return;
    }
    CGFloat fromAlpha = fromViewContrller.d_navBarAlpha;
    __weak NSArray *vcs = self.viewControllers;
    if (vcs.count < 2) {
        [self d_popViewControllerAnimated:animated];
        return;
    }
    __weak UIViewController *toViewController = [vcs objectAtIndex:vcs.count-2];
    CGFloat toAlpha = toViewController.d_navBarAlpha;
    if (fromAlpha == toAlpha) {
        [self d_popViewControllerAnimated:animated];
        return;
    }
    [self d_popViewControllerFromAlpha:fromAlpha  toAlpha:toAlpha];
    return;
}

- (void)d_updateInteractiveTransition:(CGFloat)percentComplete {
    [self d_updateInteractiveTransition:percentComplete];
    UIViewController *topVC = self.topViewController;
    if (topVC) {
        id <UIViewControllerTransitionCoordinator> transitionContext = topVC.transitionCoordinator;
        UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
        CGFloat fromAlpha = fromViewController.d_navBarAlpha;
        CGFloat toAlpha = toViewController.d_navBarAlpha;
        CGFloat currentAlpha = fromAlpha + (toAlpha-fromAlpha)*percentComplete;
        [self d_setNavigationBarAlpha:currentAlpha];
    }
}

- (void)d_viewDidLoad {
    [self d_viewDidLoad];
    UIScreenEdgePanGestureRecognizer *gesture = [self screenEdgePanGestureRecognizer];
    if (gesture) {
        [self setFullScreenEdge:[UIScreen mainScreen].bounds.size.width edgePanGesture:gesture];
        [gesture addTarget:self action:@selector(d_panGesture:)];
        
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            NSMutableArray *_targets = [gesture valueForKey:@"_targets"];
            id firstObject = [_targets firstObject];
            id lastObject = [_targets lastObject];
            [_targets replaceObjectAtIndex:0 withObject:lastObject];
            [_targets replaceObjectAtIndex:_targets.count-1 withObject:firstObject];
            [gesture setValue:_targets forKey:@"_targets"];
        });
    }
}



- (void)d_panGesture:(UIPanGestureRecognizer *)pan {
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            self.isPanGesturePop = YES;
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            self.isPanGesturePop = NO;
            if ([self.delegate isKindOfClass:[GYDTransitionManager class]]) {
                self.delegate = nil;
            }
            break;
        default:
            break;
    }
    
}


//获取侧滑返回手势
- (UIScreenEdgePanGestureRecognizer *)screenEdgePanGestureRecognizer {
    UIScreenEdgePanGestureRecognizer *screenEdgePanGestureRecognizer = nil;
    if (self.view.gestureRecognizers.count > 0) {
        for (UIGestureRecognizer *recognizer in self.view.gestureRecognizers) {
            if ([recognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
                screenEdgePanGestureRecognizer = (UIScreenEdgePanGestureRecognizer *)recognizer;
                break;
            }
        }
    }
    return screenEdgePanGestureRecognizer;
}


- (void)setFullScreenEdge:(CGFloat)edge edgePanGesture:(UIScreenEdgePanGestureRecognizer *)gesture {
    id panRecognizer = [gesture valueForKey:@"_recognizer"];
    if (panRecognizer) {
        id panSetting = [panRecognizer valueForKey:@"_settings"];
        if (panSetting) {
            id edgeSetting = [panSetting valueForKey:@"_edgeSettings"];
            if (edgeSetting) {
                [edgeSetting setValue:@(edge) forKey:@"_edgeRegionSize"];
            }
        }
    }
}




@end


@implementation UIViewController (GYDNav)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzledingViewDidAppear];
    });
}

#pragma mark - setter/getter

- (void)setD_navBarAlpha:(CGFloat)d_navBarAlpha {
    if (d_navBarAlpha > 1) d_navBarAlpha = 1;
    if (d_navBarAlpha < 0) d_navBarAlpha = 0;
    objc_setAssociatedObject(self,&D_NavBarAlpha,@(d_navBarAlpha),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)d_navBarAlpha {
    id d_navBarAlpha = objc_getAssociatedObject(self, &D_NavBarAlpha);
    if (!d_navBarAlpha) {
        return 1.0;
    }
    return [d_navBarAlpha doubleValue];
}
- (void)setD_transitionEnable:(BOOL)d_transitionEnable {
    objc_setAssociatedObject(self,&D_TransitionEnable,@(d_transitionEnable),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)d_transitionEnable {
    id d_transitionEnable = objc_getAssociatedObject(self, &D_TransitionEnable);
    if (!d_transitionEnable) {
        return YES;
    }
    return [d_transitionEnable boolValue];
}
- (void)setD_fullScreenEnable:(BOOL)d_fullScreenEnable {
    objc_setAssociatedObject(self,&D_FullScreenEnable,@(d_fullScreenEnable),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)d_fullScreenEnable {
    id d_fullScreenEnable = objc_getAssociatedObject(self, &D_FullScreenEnable);
    if (!d_fullScreenEnable) {
        return YES;
    }
    return [d_fullScreenEnable boolValue];
}



#pragma mark - swizzleding

+ (void)swizzledingViewDidAppear {
    SEL originalSelector = @selector(viewDidAppear:);
    SEL swizzledSelector = @selector(d_viewDidAppear:);
    Method originalMethod = class_getInstanceMethod([self class], originalSelector);
    Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
    BOOL didAddMethod = class_addMethod([self class],
                                        originalSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod([self class],
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


- (void)d_viewDidAppear:(BOOL)animated {
    [self d_viewDidAppear:animated];
    if (self.navigationController) {
        BOOL alpha = self.d_navBarAlpha;
        [self.navigationController d_setNavigationBarAlpha:alpha];
        BOOL d_fullScreenEnable = self.d_fullScreenEnable;
        CGFloat edge = 13;
        if (d_fullScreenEnable) {
            edge = [UIScreen mainScreen].bounds.size.width;
        }
        if (self.navigationController) {
            UIScreenEdgePanGestureRecognizer *gesture = [self.navigationController screenEdgePanGestureRecognizer];
            if (gesture) {
                [self.navigationController setFullScreenEdge:edge edgePanGesture:gesture];
            }
        }
    }
}


@end



