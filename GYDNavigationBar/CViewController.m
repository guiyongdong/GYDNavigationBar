//
//  CViewController.m
//  GYDNavBarDemo
//
//  Created by 贵永冬 on 2017/3/14.
//  Copyright © 2017年 贵永冬. All rights reserved.
//

#import "CViewController.h"

@interface CViewController ()

@end

@implementation CViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"正常的控制器";
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CViewController *vc = [[CViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}




@end
