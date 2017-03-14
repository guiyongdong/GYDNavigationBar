//
//  ViewController.m
//  GYDNavBarDemo
//
//  Created by 贵永冬 on 2017/3/13.
//  Copyright © 2017年 贵永冬. All rights reserved.
//

#import "ViewController.h"
#import "BTableViewController.h"
#import "UIViewController+GYDNav.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor yellowColor];
    self.d_navBarAlpha = 1.0;
    NSLog(@"%f",self.d_navBarAlpha);
    [self.navigationController d_setNavigationBarAlpha:0.5];
    self.title = @"第一个";
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    BTableViewController *vc = [[BTableViewController alloc] init];
    self.d_transitionEnable = YES;
    [self.navigationController d_pushViewController:vc fromAlpha:1.0 toAlpha:0];
}



@end
