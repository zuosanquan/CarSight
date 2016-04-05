//
//  UIColor+Util.h
//  MyLimitFree
//
//  Created by Edward on 16/2/15.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Util)
/**
 *  用十六进制数制定颜色
 *
 *  @param hexValue 配色卡中的16进制数
 *
 *  @return 返回颜色
 */
+ (instancetype) colorWithHexValue:(NSInteger) hexValue;
/**用十六进制数和alpha制定颜色*/
+ (instancetype) colorWithHexValue:(NSInteger)hexValue alpha:(CGFloat) alpha;
/**导航栏标题颜色*/
+ (instancetype) barTitleColor;
/**按钮标题颜色*/
+ (instancetype) buttonTitleColor;
/**cell内容栏标题颜色*/
+ (instancetype) contentTitleColor;
/**除了标题之外的其他颜色*/
+ (instancetype) cellOtherContentColor;
/**删除线颜色*/
+ (instancetype) deleteLineColor;
@end
