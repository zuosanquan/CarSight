//
//  EBCollectCell.m
//  MyLimitFree
//
//  Created by Edward on 16/2/18.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCollectCell.h"
#import "EBCarDetailModel.h"
#import "EBRecommendIconButton.h"

#define sizeRating 1.2

@implementation EBCollectCell{
    UIButton *_appButton;
    UIButton *_deleteButton;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _deleteButton.frame = CGRectMake(0, 0, 24, 24);
        [_deleteButton setBackgroundImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(deleteButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_deleteButton];
        
        _appButton = [EBRecommendIconButton buttonWithType:UIButtonTypeCustom];
        _appButton.frame = CGRectMake(CGRectGetWidth(_deleteButton.frame) / 2, CGRectGetHeight(_deleteButton.frame) / 2, CGRectGetWidth(frame) - 20, (CGRectGetHeight(frame) - 20) / sizeRating);
        [_appButton setTitleColor:[UIColor buttonTitleColor] forState:UIControlStateNormal];
        _appButton.imageView.layer.cornerRadius = 10;
        _appButton.imageView.layer.masksToBounds = YES;
        _appButton.titleLabel.font = [UIFont headViewSmallFont];
        _appButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_appButton addTarget:self action:@selector(appButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_appButton];
        [self.contentView sendSubviewToBack:_appButton];
        
        
    }
    return self;
}

- (void) deleteButtonClick:(UIButton *)button{
    if (_edit) {
        //在编辑状态下点击删除按钮移除收藏
        [_delegate deleteButtonClick:self];
    }
}

- (void)appButtonClick:(UIButton *)button{
    if (!_edit) {
        //非编辑状态下点击按钮跳转
        [_delegate appButtonClick:self];
    }
}
- (void)setModel:(EBCarSeriallist *)model{
    _model = model;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, nil), ^{
    NSString *imageStr = nil;
    if ([model.Picture containsString:@"{"]) {
        NSString *str = [[model.Picture componentsSeparatedByString:@"{"] firstObject];
        NSString *urlStr = [str stringByAppendingString:@"3.jpg"];
        imageStr = urlStr;
    }else{
        imageStr = model.Picture;
    }
   
//    });
    
    [_appButton sd_setImageWithURL:[NSURL URLWithString:imageStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Icon-60"]];
   
    [_appButton setTitle:model.serialName forState:UIControlStateNormal];
}

- (void)setEdit:(BOOL)edit{
    _edit = edit;
    _deleteButton.hidden = !edit;
}


@end
