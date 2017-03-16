//
//  CViewController.m
//  GYDNavBarDemo
//
//  Created by 贵永冬 on 2017/3/14.
//  Copyright © 2017年 贵永冬. All rights reserved.
//

#import "CViewController.h"
#import "UIViewController+GYDNav.h"

@interface CViewController ()

@end

@implementation CViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"正常的控制器";
    
    
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan)];
    [self.view addGestureRecognizer:gesture];
    
    self.d_fullScreenEnable = NO;
    
}




- (void)pan {
    NSLog(@"---");
}


@end
