//
//  UIFont+Util.h
//  CrazyCar
//
//  Created by Edward on 16/3/2.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Util)

/**头视图的Label小字体*/
+ (UIFont *) headViewSmallFont;
/**头视图的带颜色字体*/
+ (UIFont *) headViewColorTextFont;
/**头视图的正常字体*/
+ (UIFont *) headViewNormalTextFont;
/**10号字体*/
+ (UIFont *)smallestTextFont;
@end
