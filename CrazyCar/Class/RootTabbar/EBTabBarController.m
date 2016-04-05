//
//  EBTabBarController.m
//  CrazyCar
//
//  Created by Edward on 16/2/29.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBTabBarController.h"
#import "EBTabBar.h"
#import "EBChooseViewController.h"
#import "EBRightViewController.h"
#import "EBHotNewsController.h"
#import "EBCarTableViewController.h"
#import "EBVedioController.h"
@interface EBTabBarController ()

@property (nonatomic,strong) EBTabBar *customTabbar;

@end

@implementation EBTabBarController

- (EBTabBar *)customTabbar{
    if (!_customTabbar) {
        EBTabBar *myTabbar = [[EBTabBar alloc] initWithFrame:self.view.bounds];
        _customTabbar = myTabbar;
        [self.tabBar addSubview:myTabbar];
    }
    return _customTabbar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationController *hotNew = [[UINavigationController alloc] initWithRootViewController:[EBHotNewsController new]];
    [hotNew.tabBarItem setTitle:@"头条"];
    [hotNew.tabBarItem setImage:[UIImage imageNamed:@"emoji_keybord_bell_icon"]];
    [hotNew.tabBarItem setSelectedImage:[UIImage imageNamed:@"emoji_keybord_bell_sicon"]];
    [self addChildViewController:hotNew];
    
    
    UINavigationController *left = [[UINavigationController alloc]initWithRootViewController:[EBChooseViewController new]];
    [left.tabBarItem setTitle:@"选车"];
    [left.tabBarItem setImage:[UIImage imageNamed:@"emoji_keybord_car_icon"]];
    [left.tabBarItem setSelectedImage:[UIImage imageNamed:@"emoji_keybord_car_sicon"]];
    [self addChildViewController:left];
    
    EBVedioController *vedio = [EBVedioController new];
    UINavigationController *vedioNC = [[UINavigationController alloc] initWithRootViewController:vedio];
    [vedioNC.tabBarItem setImage:[UIImage imageNamed:@"label_bar_film_list_normal"]];
    [vedioNC.tabBarItem setSelectedImage:[UIImage imageNamed:@"label_bar_film_list_normal"]];
    [vedioNC.tabBarItem setTitle:@"视频"];
    [self addChildViewController:vedioNC];
    
    UINavigationController *myVC = [[UINavigationController alloc] initWithRootViewController:[EBCarTableViewController new]];
    [myVC.tabBarItem setTitle:@"我的"];
    [myVC.tabBarItem setImage:[UIImage imageNamed:@"label_bar_my_normal"]];
    [myVC.tabBarItem setSelectedImage:[UIImage imageNamed:@"label_bar_my_normal"]];
    [self addChildViewController:myVC];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
