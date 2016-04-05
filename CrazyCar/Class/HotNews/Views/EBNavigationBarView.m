//
//  EBNavigationBarView.m
//  CrazyCar
//
//  Created by Edward on 16/3/5.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBNavigationBarView.h"
#define kDefaultLabelTagStart 700


@interface EBNavigationBarView()



@end

@implementation EBNavigationBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.userInteractionEnabled = true;
    CGFloat eachW = kHotNewBarViewEachW;
    
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.bounds = CGRectMake(0, 0, eachW, 30);
        label.center = CGPointMake((i + 1.5) * eachW + eachW / 2, 23);
        //开启label交互
        label.userInteractionEnabled = true;
        //设置tag值
        label.tag = i + kDefaultLabelTagStart;
        [self addSubview:label];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [label addGestureRecognizer:tap];
        
    }
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(1.5 * eachW, CGRectGetHeight(self.frame) - 3, eachW, 2)];
    self.lineView.backgroundColor = [UIColor blueColor];
    [self addSubview:self.lineView];
}

- (void)tapClick:(UITapGestureRecognizer *)tap{
    if ([_barDelegate conformsToProtocol:@protocol(EBNavigationBarViewDelegate)]) {
        [_barDelegate customNavigationBar:self withTag:tap.view.tag - kDefaultLabelTagStart];
    }
    
}

- (void)setTitleArr:(NSArray *)titleArr{
    _titleArr = titleArr;
    for (int i = 0; i < _titleArr.count; i++) {
        UILabel *label = (UILabel *)[self viewWithTag:i + kDefaultLabelTagStart];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = _titleArr[i];
    }
}

@end
