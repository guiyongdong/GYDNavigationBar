//
//  GYDNavViewController.m
//  GYDNavBarDemo
//
//  Created by 贵永冬 on 2017/3/13.
//  Copyright © 2017年 贵永冬. All rights reserved.
//

#import "GYDNavViewController.h"

@interface GYDNavViewController ()

@end

@implementation GYDNavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}




@end
