//
//  UIViewController+GYDNav.h
//  GYDNavBarDemo
//
//  Created by 贵永冬 on 2017/3/13.
//  Copyright © 2017年 贵永冬. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIViewController (GYDNav)

/**
 当前navigationBar的透明度 默认1.0
 */
@property (nonatomic, assign) CGFloat d_navBarAlpha;

/**
 是否启用转场动画 默认YES  此转场动画代理只在动画即将开始时启用在结束时废弃
 */
@property (nonatomic, assign) BOOL d_transitionEnable;


/**
 是否启用全屏侧滑返回 默认YES
 */
@property (nonatomic, assign) BOOL d_fullScreenEnable;



@end


@interface UINavigationController (GYDNav)


/**
 设置导航栏的alpha  非动画型
 
 @param alpha 透明度
 */
- (void)d_setNavigationBarAlpha:(CGFloat)alpha;


/**
 设置导航栏线是否隐藏

 @param hidden 是否隐藏
 */
- (void)d_setShaowViewHidden:(BOOL)hidden;


/**
 在push下一个控制器之前 添加转场动画代理 动态地修改导航栏的alpha 防止突兀

 @param viewController toViewController
 @param fromAlpha 上一个控制器所持有的Alpha
 @param toAlpha 下一个控制器所持有的Alpha
 */
- (void)d_pushViewController:(UIViewController *)viewController fromAlpha:(CGFloat)fromAlpha toAlpha:(CGFloat)toAlpha;


@end
