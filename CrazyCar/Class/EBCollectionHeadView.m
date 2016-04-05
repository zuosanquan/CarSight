//
//  EBCollectionHeadView.m
//  CrazyCar
//
//  Created by Edward on 16/3/3.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCollectionHeadView.h"

@implementation EBCollectionHeadView{
    UILabel *_headTitle;
    UILabel *_allLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void) creatUI{
    CGFloat marginWH = 10;
     _headTitle = [[UILabel alloc] initWithFrame:CGRectMake(marginWH, 5, (WIDTH - 2 * marginWH) / 2, 30)];
    _allLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_headTitle.frame), CGRectGetMinY(_headTitle.frame), (WIDTH - 2 * marginWH) / 2, CGRectGetHeight(_headTitle.frame))];

    [self addSubview:_headTitle];
    [self addSubview:_allLabel];
}

- (void)setTitleName:(NSString *)titleName{
    _titleName = titleName;
    _headTitle.text = titleName;
    _headTitle.font = [UIFont boldSystemFontOfSize:20];
}

- (void)setAllLabelName:(NSString *)allLabelName{
    _allLabelName = allLabelName;
    
    _allLabel.textAlignment = NSTextAlignmentRight;
    _allLabel.textColor = [UIColor cellOtherContentColor];
    _allLabel.font = [UIFont headViewSmallFont];

    _allLabel.text = allLabelName;
}

@end
