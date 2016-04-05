//
//  EBNavigationBarView.h
//  CrazyCar
//
//  Created by Edward on 16/3/5.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBNavigationBarView;

@protocol EBNavigationBarViewDelegate <NSObject>

- (void)customNavigationBar:(EBNavigationBarView *)barView withTag:(NSInteger) index;

@end

@interface EBNavigationBarView : UIView

@property (nonatomic, strong) NSArray *titleArr;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, weak) id<EBNavigationBarViewDelegate> barDelegate;

@end
