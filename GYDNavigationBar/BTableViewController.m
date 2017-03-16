//
//  BTableViewController.m
//  GYDNavBarDemo
//
//  Created by 贵永冬 on 2017/3/14.
//  Copyright © 2017年 贵永冬. All rights reserved.
//

#import "BTableViewController.h"
#import "UIViewController+GYDNav.h"
#import "CViewController.h"

@interface BTableViewController ()

@end

@implementation BTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.d_navBarAlpha = 0;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    self.title = @"";
    
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    headerView.backgroundColor = [UIColor orangeColor];
    self.tableView.tableHeaderView = headerView;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"button" forState:UIControlStateNormal];
    button.frame = CGRectMake(80, 20, 100, 44);
    button.backgroundColor = [UIColor redColor];
    [headerView addSubview:button];
    [button addTarget:self action:@selector(buttonclick) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)buttonclick {
    CViewController *vc = [[CViewController alloc] init];
    [self.navigationController d_pushViewController:vc fromAlpha:self.d_navBarAlpha toAlpha:1.0];
}


#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellId" forIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld行",indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"abc.png"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    CViewController *vc = [[CViewController alloc] init];
    [self.navigationController d_pushViewController:vc fromAlpha:self.d_navBarAlpha toAlpha:1.0];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat y = scrollView.contentOffset.y;
    CGFloat alpha = y/200.0;
    if (alpha > 1) {
        self.d_navBarAlpha = 1.0;
    }else {
        self.d_navBarAlpha = alpha;
    }
    [self.navigationController d_setNavigationBarAlpha:self.d_navBarAlpha];
}




@end
