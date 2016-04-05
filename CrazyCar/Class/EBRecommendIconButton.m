//
//  EBRecommendIconButton.m
//  MyLimitFree
//
//  Created by Edward on 16/2/17.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBRecommendIconButton.h"

static const NSUInteger kDefaultRecommendNameLabelH = 20;

@implementation EBRecommendIconButton

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, CGRectGetHeight(contentRect) - kDefaultRecommendNameLabelH, CGRectGetWidth(contentRect), kDefaultRecommendNameLabelH);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, 0, CGRectGetWidth(contentRect), CGRectGetHeight(contentRect) - kDefaultRecommendNameLabelH);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
