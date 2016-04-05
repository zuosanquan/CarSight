//
//  EBUIFactory.h
//  MyLimitFree
//
//  Created by Edward on 16/2/15.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 用户界面的工厂类
 作用：负责创建用户界面的作用试图
 设计：简单工厂模式
 */
@interface EBUIFactory : NSObject
/**
 *  创建按钮
 *
 *  @param title   按钮标题
 *  @param image   按钮图片
 *  @param bgImage 按钮背景图片
 *  @param target  按钮接受事件对象
 *  @param sel     按钮执行事件
 *
 *  @return 返回创建的按钮
 */
+ (UIButton *) creatButtonWithTitle:(NSString *) title image:(NSString *) imageUrl bgImage:(NSString *) bgImageUrl target:(id) target action:(SEL) sel frame:(CGRect) rect;
/**
 *  创建标签
 *
 *  @param title 标签标题
 *  @param rect  标签frame
 *  @param color 标签字体颜色
 *  @param color 标签背景颜色
 *  @param font  标签字体大小
 *
 *  @return 返回创建的标签
 */
+ (UILabel *) creatLabelWithTitle:(NSString *) title frame:(CGRect)rect color:(UIColor *) color bgColor:(UIColor *)bgColor font:(UIFont *)font;

@end
