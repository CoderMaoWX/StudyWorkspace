//
//  AppDelegate.m
//  StudyWorkspace
//
//  Created by 610582 on 2020/8/14.
//  Copyright © 2020 MaoWX. All rights reserved.
//

#import "AppDelegate.h"
#import "SlideAppTabBarVC.h"
#import "WXPublicHeader.h"

@interface AppDelegate ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *plainTableView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window addSubview:self.plainTableView];
    [self.window insertSubview:self.plainTableView atIndex:0];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [SlideAppTabBarVC new];
    [self.window makeKeyAndVisible];
    
    return YES;
}

#pragma mark - ========= 初始化基类表格,子类显示 =========

- (UITableView *)plainTableView {
    if (!_plainTableView) {
        _plainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        _plainTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _plainTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _plainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
        _plainTableView.tableFooterView = [UIView new];
        _plainTableView.dataSource = self;
        _plainTableView.delegate = self;
        _plainTableView.rowHeight = 80;
    }
    return _plainTableView;
}

#pragma Mark - 表格代理

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    cell.textLabel.text = [NSString stringWithFormat:@"数据源===%zd",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *tmpVC = [UIViewController new];
    tmpVC.view.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    SlideAppTabBarVC *tabbarVC = (SlideAppTabBarVC *)self.window.rootViewController;
    UINavigationController *navVC = tabbarVC.selectedViewController;
    [tabbarVC showLeftView:NO];
    navVC.hidesBottomBarWhenPushed = YES;
    [navVC pushViewController:tmpVC animated:YES];
}

@end
