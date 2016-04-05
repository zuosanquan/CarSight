//
//  UIScrollView+ScaleImage.h
//  SideMenuDemo
//
//  Created by Edward on 16/2/23.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EBScaleImageView : UIImageView

@property (nonatomic, weak) UIScrollView *scrollView;

@end


@interface UIScrollView (ScaleImage)

@property (nonatomic, weak) EBScaleImageView *scaleImageView;


//传入一张图片播放
- (void)addScaleAvariabilityImageWithImage:(NSString *)imageStr andHeight:(CGFloat) height;

//移除
- (void)removeScaleAvariabilityImage;



@end
