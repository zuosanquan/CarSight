//
//  UIColor+Util.m
//  MyLimitFree
//
//  Created by Edward on 16/2/15.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "UIColor+Util.h"

@implementation UIColor (Util)

+ (instancetype)colorWithHexValue:(NSInteger)hexValue{
    return [self colorWithHexValue:hexValue alpha:1];
}

+ (instancetype)colorWithHexValue:(NSInteger)hexValue alpha:(CGFloat)alpha{
    //&位与运算
    return [UIColor colorWithRed:((hexValue & 0xff0000) >> 16) / 255.0 green:((hexValue & 0xff00) >> 8) / 255.0 blue:(hexValue & 0xff) / 255.0 alpha:alpha];
}

+ (instancetype)barTitleColor{
    return [UIColor colorWithHexValue:0x228B22];
}

+ (instancetype)buttonTitleColor{
    return [UIColor colorWithHexValue:0x000000];
}

+ (instancetype)contentTitleColor{
    return [UIColor colorWithHexValue:0x000000];
}

+ (instancetype)cellOtherContentColor{
    return [self colorWithHexValue:0x080808 alpha:0.6];
}

+ (instancetype)deleteLineColor{
    return [UIColor grayColor];
}
@end
