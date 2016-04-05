//
//  EBAboutUsPage.m
//  CrazyCar
//
//  Created by Edward on 16/3/11.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBAboutUsPage.h"

@implementation EBAboutUsPage

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self customNavigationItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    // 设置背景图片
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"weibo_movic_navigation_bg@2x"] forBarMetrics:UIBarMetricsDefault];
    
    
}

- (void)customNavigationItem{
    
    UIColor * color = [UIColor whiteColor];
    NSDictionary * dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    
    // 获取视图控制器的UINavigationItem
    UINavigationItem * naviItem = self.navigationItem;
    
    UIImage * leftImage = [UIImage imageNamed:@"navigationbar_icon_back"];
    UIBarButtonItem * leftBarItem = [[UIBarButtonItem alloc] initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClicked:)];
    leftBarItem.tintColor = [UIColor colorWithHexValue:0x2894FF];
    naviItem.leftBarButtonItem = leftBarItem;
    
}

- (void)leftBarButtonItemClicked:(UIBarButtonItem *)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
