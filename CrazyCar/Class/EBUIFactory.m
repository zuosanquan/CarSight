//
//  EBUIFactory.m
//  MyLimitFree
//
//  Created by Edward on 16/2/15.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBUIFactory.h"
#import "UIColor+Util.h"
@implementation EBUIFactory

+ (UIButton *) creatButtonWithTitle:(NSString *)title image:(NSString *)imageUrl bgImage:(NSString *)bgImageUrl target:(id)target action:(SEL)sel frame:(CGRect)rect {
//    创建自定义按钮
    UIButton *button = [[UIButton alloc] init];
//    设置按钮frame
    button.frame = rect;
//    根据参数设置按钮
    if (imageUrl) {
        if ([imageUrl hasPrefix:@"http"]) {
            [button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal];
        }else{
            [button setImage:[UIImage imageNamed:imageUrl] forState:UIControlStateNormal];
        }
    }
    if (bgImageUrl) {
        if ([bgImageUrl hasPrefix:@"http"]) {
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:bgImageUrl] forState:UIControlStateNormal];
        }else{
            [button setBackgroundImage:[UIImage imageNamed:bgImageUrl] forState:UIControlStateNormal];
        }
    }
    if (title) {
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont headViewNormalTextFont];
    }
    if (target && sel) {
        [button addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    }
//    设置标题颜色
    [button setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
//    设置标题字号
    button.titleLabel.font = [UIFont systemFontOfSize:20];
    
    return button;
}

+ (UILabel *) creatLabelWithTitle:(NSString *)title frame:(CGRect)rect color:(UIColor *)color bgColor:(UIColor *)bgColor font:(UIFont *)font {
//    自定义创建标签
    UILabel *label = [[UILabel alloc] init];
//    设置frame
    label.frame = rect;
//    根据参数设置label
    if (title) {
        label.text = title;
    }
    if (color) {
        label.textColor = color;
    }
    if (bgColor) {
        label.backgroundColor = bgColor;
    }
    label.textAlignment = NSTextAlignmentCenter;
//    设置字体大小
    label.font = font;
    
    return label;
}
@end
