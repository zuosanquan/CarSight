//
//  EBSelfInfoHeadView.m
//  CrazyCar
//
//  Created by Edward on 16/3/7.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBSelfInfoHeadView.h"

@implementation EBSelfInfoHeadView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    CGFloat marginW = 15;
    CGFloat labelH = 20;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(marginW, (CGRectGetHeight(self.frame) - labelH) / 2, 50, labelH)];
    label.text = @"头像";
    [self addSubview:label];
    
    CGFloat imageW = 80;
    CGFloat behindW = 20;
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(WIDTH - imageW - behindW, (CGRectGetHeight(self.frame) - imageW) / 2, imageW, imageW)];
    
    //从沙盒中取出照片
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = [user objectForKey:@"userImage"];
    self.image = [UIImage imageWithData:data];
    if (self.image == nil) {
        self.headImage.image = [UIImage imageNamed:@"Icon-60"];
    }else if (self.image){
        self.headImage.image = self.image;
    }
    self.headImage.layer.masksToBounds = YES;
    self.headImage.layer.cornerRadius = imageW / 2;
    [self addSubview:self.headImage];
    
}

- (void)setImage:(UIImage *)image{
    _image = image;
    self.headImage.image = self.image;
    
    //将设置的照片存进沙盒
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSData *data = UIImagePNGRepresentation(_image);
    [user setObject:data forKey:@"userImage"];
    [user synchronize];
}

@end
