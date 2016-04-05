//
//  EBCollectCell.h
//  MyLimitFree
//
//  Created by Edward on 16/2/18.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EBCollectCell;

@protocol EBCollectCellDelegate <NSObject>

- (void) appButtonClick:(EBCollectCell *) collectCell;

- (void) deleteButtonClick:(EBCollectCell *) collectCell;
@end


@class EBCarSeriallist;

@interface EBCollectCell : UICollectionViewCell

@property (nonatomic , strong) EBCarSeriallist *model;

@property (nonatomic , assign) BOOL edit;

@property (nonatomic , assign) id<EBCollectCellDelegate> delegate;

@end
