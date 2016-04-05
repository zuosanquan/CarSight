//
//  EBCollectionViewCell.h
//  SideMenuDemo
//
//  Created by Edward on 16/2/23.
//  Copyright © 2016年 Edward. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EBCollectionViewCellDelegate <NSObject>

- (void) longpressToSaveAlbum:(UIImage *)desImage;

@end

@interface EBCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *desLabel;

@property (assign,nonatomic) NSInteger currentPage;
@property (assign,nonatomic) NSInteger pages;

@property (nonatomic, weak) id<EBCollectionViewCellDelegate> cellDelegate;

@end
