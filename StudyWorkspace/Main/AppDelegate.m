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
    [self.window insertSubview:self.plainTableView atIndex:0];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [SlideAppTabBarVC new];
    [self.window makeKeyAndVisible];
    
    //查看一键切换启动图效果
    if ([WX_GetUserDefault(kSavedLaunchImgKey) boolValue]) {
        WX_SaveUserDefault(kSavedLaunchImgKey, @(NO));
        sleep(1);
    }
    return YES;
}

#pragma mark - ========= 初始化基类表格,子类显示 =========

- (UITableView *)plainTableView {
    if (!_plainTableView) {
        _plainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStylePlain];
        UIImageView *imageV = [[UIImageView alloc] initWithImage:WX_ImageName(@"sidebar_fullbg")];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        _plainTableView.backgroundView = imageV;
        _plainTableView.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
        _plainTableView.tableHeaderView = [UIView new];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIViewController *tmpVC = [UIViewController new];
    tmpVC.view.backgroundColor = cell.backgroundColor;
    tmpVC.title = cell.textLabel.text;
    tmpVC.hidesBottomBarWhenPushed = YES;
    
    SlideAppTabBarVC *tabbarVC = (SlideAppTabBarVC *)self.window.rootViewController;
    [tabbarVC showLeftView:NO];
    UINavigationController *navVC = tabbarVC.selectedViewController;
    [navVC pushViewController:tmpVC animated:YES];
}

@end
