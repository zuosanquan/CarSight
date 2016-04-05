//
//  EBSelfCenterView.m
//  CrazyCar
//
//  Created by Edward on 16/3/8.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "EBSelfCenterView.h"

@interface EBSelfCenterView()

@property (nonatomic, strong) UIImageView *myImageView;

@property (nonatomic, strong) UILabel *nickNameLabel;

@property (nonatomic, strong) UIImageView *iconImageView;

@end

@implementation EBSelfCenterView{
    NSUserDefaults *_user;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _user = [NSUserDefaults standardUserDefaults];

        [self setupUI];
        NSData *data = [_user objectForKey:@"userImage"];
        if (data) {
            self.selfImage = [UIImage imageWithData:data];
        }else{
            self.selfImage = [UIImage imageNamed:@"Image_head"];
        }
        NSString *name = [_user objectForKey:@"nickName"];
        if (name.length > 0) {
            self.nickName = name;
        }else{
            self.nickName = @"昵称";
        }
        NSString *log = [_user objectForKey:@"logUrl"];
        if (log.length > 0) {
            self.logUrl = log;
        }
        
    }
    return self;
}

- (void)setupUI{
    CGFloat marginW = 20;
    CGFloat myImageW = CGRectGetHeight(self.frame) / 2;
    self.myImageView = [[UIImageView alloc] initWithFrame:CGRectMake(marginW, myImageW / 2, myImageW, myImageW)];
    self.myImageView.layer.masksToBounds = YES;
    self.myImageView.layer.cornerRadius = myImageW / 2;
    [self addSubview:self.myImageView];
    
}

- (void)setSelfImage:(UIImage *)selfImage{
    _selfImage = selfImage;

    self.myImageView.image = _selfImage;
}

- (void)setNickName:(NSString *)nickName{
    _nickName = nickName;

    CGSize size = [_nickName sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]}];
    CGFloat labelH = 30;
    if (!_nickNameLabel) {
        self.nickNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.myImageView.frame) + 10, CGRectGetMidY(self.myImageView.frame) - labelH / 2, size.width, labelH)];
        [self addSubview:self.nickNameLabel];
    }
    self.nickNameLabel.textColor = [UIColor whiteColor];
    self.nickNameLabel.text = _nickName;
}

- (void)setLogUrl:(NSString *)logUrl{

    _logUrl = logUrl;

    CGFloat X = CGRectGetMaxX(self.myImageView.frame) + 15 + CGRectGetWidth(self.nickNameLabel.frame);
    CGFloat W = 30;
    CGFloat Y = CGRectGetMidY(self.myImageView.frame) - W / 2;
    if (!self.iconImageView) {
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(X, Y, W, W)];
        [self addSubview:self.iconImageView];
    }
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:_logUrl]];
}

@end
