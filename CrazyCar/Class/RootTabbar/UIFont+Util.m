//
//  UIFont+Util.m
//  CrazyCar
//
//  Created by Edward on 16/3/2.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "UIFont+Util.h"

@implementation UIFont (Util)

+ (UIFont *)headViewSmallFont{
    return [UIFont systemFontOfSize:12];
}

+ (UIFont *)headViewColorTextFont{
    return [UIFont systemFontOfSize:15];
}

+ (UIFont *)headViewNormalTextFont{
    return [UIFont systemFontOfSize:14];
}

+ (UIFont *)smallestTextFont{
    return [UIFont systemFontOfSize:10];
}
@end
