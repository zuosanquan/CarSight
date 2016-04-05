//
//  JokerViewController.m
//  MovieFans
//
//  Created by 钟义 on 16/2/13.
//  Copyright © 2016年 joker. All rights reserved.
//

#import "JokerViewController.h"
#import "FadeStringView.h"
#import "CopyiPhoneFadeView.h"
#import "UIView+Twinkle.h"

@interface JokerViewController ()
{
    UIButton * twinkleButton;
}
@end

@implementation JokerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexValue:0x6FB7B7];
    self.title = @"关于我们";
    
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createUI{
    
    FadeStringView *fadeStringView = [[FadeStringView alloc] initWithFrame:CGRectMake(20, HEIGHT / 5, WIDTH - 40, 40)];
    fadeStringView.text = @"Thanks";
    fadeStringView.foreColor = [UIColor whiteColor];
    fadeStringView.backColor = [UIColor redColor];
    fadeStringView.font = [UIFont systemFontOfSize:40];
    fadeStringView.alignment = NSTextAlignmentCenter;
    //fadeStringView.center = self.view.center;
    [self.view addSubview:fadeStringView];
    [fadeStringView fadeRightWithDuration:2];
    
    twinkleButton = [[UIButton alloc]initWithFrame:CGRectMake(20, HEIGHT-99, WIDTH-40, 30)];
    [self.view addSubview:twinkleButton];
    [twinkleButton setTitle:@"Join us" forState:UIControlStateNormal];
    twinkleButton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-Regular" size:30];
    twinkleButton.titleLabel.textColor = [UIColor whiteColor];
    [twinkleButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSString *fadeString = @"The world of car, strolling around there is always a satisfactory in here, you can also view the dynamics of the car at any time!";
    
    CopyiPhoneFadeView *iphoneFade = [[CopyiPhoneFadeView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(fadeStringView.frame) + 10, WIDTH - 40, HEIGHT / 3)];
    iphoneFade.text = fadeString;
    iphoneFade.foreColor = [UIColor whiteColor];
    iphoneFade.backColor = [UIColor redColor];
    iphoneFade.font = [UIFont systemFontOfSize:30];
    iphoneFade.alignment = NSTextAlignmentCenter;
    
    [self.view addSubview:iphoneFade];
    
    [iphoneFade iPhoneFadeWithDuration:2];

}

- (void)buttonClicked:(UIButton *)sender{
    
    //UIButton *btn = (UIButton *)sender;
    // 动画开始
    [twinkleButton twinkle];
}

@end
