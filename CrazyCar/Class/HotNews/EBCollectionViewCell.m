//
//  EBCollectionViewCell.m
//  SideMenuDemo
//
//  Created by Edward on 16/2/23.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBCollectionViewCell.h"

@implementation EBCollectionViewCell

- (void)awakeFromNib{
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexValue:0xCCFFCC];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    CGFloat margin = 5;
    CGFloat bMargin = 3;
    CGFloat labelH = 100;
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, CGRectGetWidth(self.contentView.frame) - 2 * margin, CGRectGetHeight(self.contentView.frame) - labelH)];
    self.imageView.userInteractionEnabled = YES;
    //添加长按保存手势
    UILongPressGestureRecognizer *longpress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(savePicToAlbums:)];
    [self.imageView addGestureRecognizer:longpress];
    [self.contentView addSubview:self.imageView];
    
    self.desLabel = [[UILabel alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(self.imageView.frame) + bMargin, CGRectGetWidth(self.imageView.frame), labelH - 2 * bMargin)];
    
    [self.contentView addSubview:self.desLabel];
}

- (void) savePicToAlbums :(UILongPressGestureRecognizer *)longpress{
    if ([self.cellDelegate conformsToProtocol:@protocol(EBCollectionViewCellDelegate)]) {
        UIImageView *imageView = (UIImageView *)longpress.view;
        [self.cellDelegate longpressToSaveAlbum:imageView.image];
    }
}
@end
