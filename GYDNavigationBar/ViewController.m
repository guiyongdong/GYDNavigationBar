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
    
    self.view.backgroundColor = [UIColor yellowColor];
    self.d_navBarAlpha = 1.0;
//    [self.navigationController d_setNavigationBarAlpha:1.0];
    self.title = @"第一个";

}


- (IBAction)push:(id)sender {
    BTableViewController *vc = [[BTableViewController alloc] init];
    [self.navigationController d_pushViewController:vc fromAlpha:1.0 toAlpha:0];
}



@end
