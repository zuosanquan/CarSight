//
//  VMTabBar.h
//  VMTabbarCustomize
//
//  Created by Vu Mai on 4/21/15.
//  Copyright (c) 2015 VuMai. All rights reserved.
//

#import <UIKit/UIKit.h>
#define rgb(r,g,b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1]

@protocol EBTabBarDelegate;

@interface EBTabBar : UIView
/**协议指针*/
@property (nonatomic) id<EBTabBarDelegate> delegate;
/**tabbar个数*/
-(void)iconTabBarWithNumber:(NSInteger)num;
/**tabbar上的字号*/
-(void)setFontTabBar:(UIFont*)font;
/**增加item的text*/
-(void)addListOfItemText:(NSMutableArray*)arr;
/**增加tabbar图片数组*/
-(void)addListOfItemImage:(NSMutableArray*)arr;
/**选择tabbar的tag*/
-(void)selectTabBarValueWithTag:(NSInteger)tag;

-(void)changeColorTabbarWithColor:(UIColor*)color;

-(void)addListOfViewWhenClickTabbar:(NSMutableArray*)arr;

@end

@protocol EBTabBarDelegate <NSObject>

@required

-(void)VMTabBar:(EBTabBar*)tabbar switchTabWithTag:(NSInteger)tag;

@end