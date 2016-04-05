//
//  UIScrollView+ScaleImage.m
//  SideMenuDemo
//
//  Created by Edward on 16/2/23.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import "UIScrollView+ScaleImage.h"
#import <objc/runtime.h>
const NSString *keyScaleImage = @"keyScaleImage";

NSString *kcontentOffset = @"contentOffset";

@interface EBScaleImageView(){
    CGFloat _height;
    CGFloat _width;
}



@end

@implementation EBScaleImageView

- (void)setScrollView:(UIScrollView *)scrollView{
    //先要移除旧的观察者
    [_scrollView removeObserver:self forKeyPath:kcontentOffset];

    //监听scrollView.contentOffset
    _scrollView = scrollView;
    //记录初始高度
    _height = CGRectGetHeight(self.frame);
    _width = CGRectGetWidth(self.frame);
    [_scrollView addObserver:self forKeyPath:kcontentOffset options:NSKeyValueObservingOptionNew context:nil];
}
/*NSObject的方法**/
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    //观察到变化后的回调方法
    //让self(EBScaleImageView) 去改变frame
    //注册需要更新视图
    [self setNeedsLayout];
    //告诉当前视图需要去更新，视图会在下一个消息循环是更新
    //在使用了setNeedsLayout之后，会调用layoutSubviews
}

- (void)layoutSubviews{
    [super layoutSubviews];
    //更新视图
    
    CGFloat offsetY = self.scrollView.contentOffset.y;
    
    if (offsetY < 0) {
        CGFloat X = offsetY;
        CGFloat Y = offsetY;
        CGFloat W = CGRectGetWidth(self.scrollView.frame) + fabs(offsetY) * 2;
        CGFloat H = _height + fabs(offsetY);
        self.frame = CGRectMake(X, Y, W, H);
    }else{
        self.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.frame), _height);
    }

    
}

- (void)dealloc{
    [self.scrollView removeObserver:self forKeyPath:kcontentOffset];
}

- (void)removeFromSuperview{
    [self.scrollView removeObserver:self forKeyPath:kcontentOffset];
}

@end


@implementation UIScrollView (ScaleImage)

- (void)setScaleImageView:(EBScaleImageView * _Nullable)scaleImageView{
    //运行时的方法给当前scrollView绑定一个属性
    //参数1、被绑定的对象，给谁绑定
    //参数2、key 通过key来绑定
    //参数3、value 绑定的对象
    //参数4、绑定的策略
    objc_setAssociatedObject(self, &keyScaleImage, scaleImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (EBScaleImageView *)scaleImageView{
    return objc_getAssociatedObject(self, &keyScaleImage);
}

- (void)addScaleAvariabilityImageWithImage:(NSString *)imageStr andHeight:(CGFloat)height{
    EBScaleImageView *imageView = [[EBScaleImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), height)];
    if ([imageStr hasPrefix:@"http"]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"pic_placeholder"]];
    }else{
        imageView.image = [UIImage imageNamed:imageStr];
    }
    
    [self addSubview:imageView];
    //绑定imageView.scrollView
    imageView.scrollView = self;
    self.scaleImageView = imageView;
}

- (void)removeScaleAvariabilityImage{
    self.scaleImageView = nil;
}



@end
